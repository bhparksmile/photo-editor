//
//  PhotoEditor+UITextView.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

extension PhotoEditorViewController: TextStickerDelegate {
    
    public func textViewDidChange(_ textStickerView: TextStickerView) {
        let rotation = atan2(textStickerView.transform.b, textStickerView.transform.a)
        if rotation == 0 {
            let oldFrame = textStickerView.frame
            let sizeToFit = textStickerView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textStickerView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    public func textViewDidBeginEditing(_ textStickerView: TextStickerView) {
        self.deselectAllStickerView()
        isTyping = true
        lastTextViewTransform =  textStickerView.transform
        lastTextViewTransCenter = textStickerView.center
        lastTextViewFont = textStickerView.textView.font!
        activeTextView = textStickerView.textView
        textStickerView.isSelected = false
        textStickerView.superview?.bringSubviewToFront(textStickerView)
        textStickerView.textView.font = textFont
        UIView.animate(withDuration: 0.15,
                       animations: {
                        textStickerView.transform = CGAffineTransform.identity
                        textStickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 8,
                                                width: UIScreen.main.bounds.width, height: 100)
        }, completion: nil)
    }
    
    public func textViewDidEndEditing(_ textStickerView: TextStickerView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
            else {
                return
        }
        activeTextView = nil
        textStickerView.textView.font = self.lastTextViewFont!
        UIView.animate(withDuration: 0.15,
                       animations: {
                        textStickerView.transform = self.lastTextViewTransform!
                        textStickerView.center = self.lastTextViewTransCenter!
                       }) { isFinish in
            guard isFinish else { return }
            
            self.dummyTextView.font = textStickerView.textView.font
            self.dummyTextView.text = textStickerView.textView.text
            
            let fitsSize = CGSize(width: UIScreen.main.bounds.size.width,
                                  height:CGFloat.greatestFiniteMagnitude)
            let sizeToFit = self.dummyTextView.sizeThatFits(fitsSize)
            
            let newSize = CGSize(width: sizeToFit.width+24, height: sizeToFit.height+24)
            textStickerView.bounds.size = newSize
            
            self.deselectAllStickerView()
            textStickerView.isSelected = true
        }
    }

    func extractTextStickerView(view: UIView) -> [TextStickerView] {
        var stickerViews: [TextStickerView] = []
        for subView in view.subviews {
            if subView is TextStickerView {
                stickerViews.append(subView as! TextStickerView)
            }
        }
        return stickerViews
    }
    
}

