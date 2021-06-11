//
//  PhotoEditor+Keyboard.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit


extension PhotoEditorViewController {
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if isTyping {
            doneButton.isHidden = false
            colorPickerView.isHidden = false
            btnBack.isHidden = true
            btnFinish.isHidden = true
            hideToolbar(hide: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isTyping = false
        doneButton.isHidden = true
        btnBack.isHidden = false
        btnFinish.isHidden = false
        hideToolbar(hide: false)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.colorPickerViewBottomConstraint.constant = 0.0
            } else {
                self.colorPickerViewBottomConstraint.constant = -(endFrame?.size.height ?? 0.0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}

