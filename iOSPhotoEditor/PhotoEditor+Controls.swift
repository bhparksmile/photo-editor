//
//  PhotoEditor+Controls.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

// MARK: - Control
public enum control {
    case crop
    case sticker
    case draw
    case text
    case save
    case share
    case clear
}

extension PhotoEditorViewController {

     //MARK: Top Toolbar
    
    @objc func backButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func cropButtonTapped(_ sender: UIButton) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }

    @objc func stickersButtonTapped(_ sender: Any) {
        addStickersViewController()
    }

    @objc func drawButtonTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }

    @objc func textButtonTapped(_ sender: Any) {
        isTyping = true
        let textStickerView = TextStickerView(frame: CGRect(x: 0, y: self.canvasImageView.bounds.minY,
                                                            width: UIScreen.main.bounds.width,
                                                            height: self.canvasImageView.bounds.height))
        textStickerView.textView.textAlignment = .center
        textStickerView.textView.font = textFont?.withSize(30)
        textStickerView.textView.textColor = textColor
        textStickerView.textView.autocorrectionType = .no
        textStickerView.textView.isScrollEnabled = false
        textStickerView.textStickerDelegate = self
        textStickerView.layer.shadowColor = UIColor.black.cgColor
        textStickerView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textStickerView.layer.shadowOpacity = 0.2
        textStickerView.layer.shadowRadius = 1.0
        textStickerView.layer.backgroundColor = UIColor.clear.cgColor
        self.canvasImageView.addSubview(textStickerView)
        addGestures(view: textStickerView)
        textStickerView.textView.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
    }
    
    //MARK: Bottom Toolbar
    
    @objc func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [canvasView.toImage()], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @objc func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @objc func continueButtonPressed(_ sender: Any) {
        self.deselectAllStickerView()
//        self.canvasView.setNeedsDisplay()
//        self.canvasView.layoutIfNeeded()
        let img = self.canvasView.toImage()
        photoEditorDelegate?.doneEditing(image: img)
        self.dismiss(animated: true, completion: nil)
    }

    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideControls() {
        for control in hiddenControls {
            switch control {
                
            case .clear:
                clearButton.isHidden = true
            case .crop:
                cropButton.isHidden = true
            case .draw:
                drawButton.isHidden = true
            case .save:
                saveButton.isHidden = true
            case .share:
                shareButton.isHidden = true
            case .sticker:
                stickerButton.isHidden = true
            case .text:
                stickerButton.isHidden = true
            }
        }
    }
    
}

