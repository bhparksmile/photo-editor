//
//  PhotoEditor+StickersViewController.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

extension PhotoEditorViewController {
    
    func addStickersViewController() {
        stickersVCIsVisible = true
        hideToolbar(hide: true)
        self.canvasImageView.isUserInteractionEnabled = false
        stickersViewController.stickersViewControllerDelegate = self
        
//        for image in self.stickers {
//            stickersViewController.stickers.append(image)
//        }
        self.addChild(stickersViewController)
        self.view.addSubview(stickersViewController.view)
        stickersViewController.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        stickersViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func removeStickersView() {
        stickersVCIsVisible = false
        self.canvasImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.stickersViewController.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.stickersViewController.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.stickersViewController.view.removeFromSuperview()
            self.stickersViewController.removeFromParent()
            self.hideToolbar(hide: false)
        })
    }
    
    func extractStickerView(view: UIView) -> [StickerView] {
        var stickerViews: [StickerView] = []
        for subView in view.subviews {
            if subView is StickerView {
                stickerViews.append(subView as! StickerView)
            }
        }
        return stickerViews
    }
    
    func deselectAllStickerView() {
        for subView in self.canvasImageView.subviews {
            if subView is StickerView {
                (subView as! StickerView).isSelected = false
            } else if subView is TextStickerView {
                (subView as! TextStickerView).isSelected = false
            }
        }
    }
}

extension PhotoEditorViewController: StickersViewControllerDelegate {
    
    func didSelectView(view: UIView) {
        self.removeStickersView()
        self.deselectAllStickerView()
        
        view.center = canvasImageView.center
        self.canvasImageView.addSubview(view)
        //Gestures
        addGestures(view: view)
    }
    
    func didSelectImage(image: UIImage) {
        self.removeStickersView()
        self.deselectAllStickerView()
        
        let stickerView = StickerView()
        stickerView.frame.size = CGSize(width: 150, height: 150)
        stickerView.center = canvasImageView.center
        stickerView.imageView.image = image
        stickerView.isSelected = true
        
        self.canvasImageView.addSubview(stickerView)
        //Gestures
        addGestures(view: stickerView)
    }
    
    func stickersViewDidDisappear() {
        stickersVCIsVisible = false
        self.removeStickersView()
        hideToolbar(hide: false)
    }
    
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(PhotoEditorViewController.pinchGesture))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action:#selector(PhotoEditorViewController.rotationGesture) )
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoEditorViewController.tapGesture))
        view.addGestureRecognizer(tapGesture)
        
    }

}
