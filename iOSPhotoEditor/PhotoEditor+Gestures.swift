//
//  PhotoEditor+Gestures.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit



extension PhotoEditorViewController : UIGestureRecognizerDelegate  {
    
    /**
     UIPanGestureRecognizer - Moving Objects
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                //Tap only on visible parts on the image
                if recognizer.state == .began {
                    for stickerView in extractStickerView(view: canvasImageView) {
                        let location = recognizer.location(in: stickerView)
                        let alpha = stickerView.alphaAtPoint(location)
                        if alpha > 0 {
                            imageViewToPan = stickerView
                            break
                        }
                    }
                }
                if imageViewToPan != nil {
                    moveView(view: imageViewToPan!, recognizer: recognizer)
                }
            } else {
                moveView(view: view, recognizer: recognizer)
            }
        }
    }
    
    /**
     UIPinchGestureRecognizer - Pinching Objects
     If it's a UITextView will make the font bigger so it doen't look pixlated
     */
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            if let stickerView = view as? TextStickerView {
                if stickerView.textView.font!.pointSize * recognizer.scale < 90 {
                    let font = UIFont(name: stickerView.textView.font!.fontName, size: stickerView.textView.font!.pointSize * recognizer.scale)
                    stickerView.textView.font = font
                    dummyTextView.font = font
                    dummyTextView.text = stickerView.textView.text
                    
                    let fitsSize = CGSize(width: UIScreen.main.bounds.size.width,
                                          height:CGFloat.greatestFiniteMagnitude)
                    let sizeToFit = dummyTextView.sizeThatFits(fitsSize)
                    
                    let newSize = CGSize(width: sizeToFit.width+24, height: sizeToFit.height+24)
                    stickerView.bounds.size = newSize
                } else {
                    let sizeToFit = stickerView.textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width,
                                                                 height:CGFloat.greatestFiniteMagnitude))
                    stickerView.bounds.size = CGSize(width: stickerView.textView.intrinsicContentSize.width+24,
                                                  height: sizeToFit.height+24)
                }
                
                stickerView.setNeedsDisplay()
            } else {
                view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            }
            recognizer.scale = 1
        }
    }
    
    /**
     UIRotationGestureRecognizer - Rotating Objects
     */
    @objc func rotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    /**
     UITapGestureRecognizer - Taping on Objects
     Will make scale scale Effect
     Selecting transparent parts of the imageview won't move the object
     */
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            self.deselectAllStickerView()
            if view is StickerView {
                //Tap only on visible parts on the image
                for stickerView in extractStickerView(view: canvasImageView) {
                    let location = recognizer.location(in: stickerView)
                    let alpha = stickerView.alphaAtPoint(location)
                    if alpha > 0 {
                        stickerView.isSelected = true
                        scaleEffect(view: stickerView)
                        break
                    }
                }
            } else if view is TextStickerView {
                (view as! TextStickerView).isSelected = true
            } else {
                scaleEffect(view: view)
            }
        }
    }
    
    /*
     Support Multiple Gesture at the same time
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !stickersVCIsVisible {
                addStickersViewController()
            }
        }
    }
    
    // to Override Control Center screen edge pan from bottom
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    /**
     Scale Effect
     */
    func scaleEffect(view: UIView) {
        view.superview?.bringSubviewToFront(view)
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        let previouTransform =  view.transform
        UIView.animate(withDuration: 0.2,
                       animations: {
                        view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            view.transform  = previouTransform
                        }
        })
    }
    
    /**
     Moving Objects
     delete the view if it's inside the delete view
     Snap the view back if it's out of the canvas
     */

    func moveView(view: UIView, recognizer: UIPanGestureRecognizer)  {
//        hideToolbar(hide: true)
//        deleteView.isHidden = false
        
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)

        view.center = CGPoint(x: view.center.x + recognizer.translation(in: canvasImageView).x,
                              y: view.center.y + recognizer.translation(in: canvasImageView).y)
        
        recognizer.setTranslation(CGPoint.zero, in: canvasImageView)
        
//        if let previousPoint = lastPanPoint {
//            //View is going into deleteView
//            if deleteView.frame.contains(pointToSuperView) && !deleteView.frame.contains(previousPoint) {
//                if #available(iOS 10.0, *) {
//                    let generator = UIImpactFeedbackGenerator(style: .heavy)
//                    generator.impactOccurred()
//                }
//                UIView.animate(withDuration: 0.3, animations: {
//                    view.transform = view.transform.scaledBy(x: 0.25, y: 0.25)
//                    view.center = recognizer.location(in: self.canvasImageView)
//                })
//            }
//                //View is going out of deleteView
//            else if deleteView.frame.contains(previousPoint) && !deleteView.frame.contains(pointToSuperView) {
//                //Scale to original Size
//                UIView.animate(withDuration: 0.3, animations: {
//                    view.transform = view.transform.scaledBy(x: 4, y: 4)
//                    view.center = recognizer.location(in: self.canvasImageView)
//                })
//            }
//        }
        lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            imageViewToPan = nil
            lastPanPoint = nil
            hideToolbar(hide: false)
//            deleteView.isHidden = true
//            let point = recognizer.location(in: self.view)
            
//            if deleteView.frame.contains(point) { // Delete the view
//                view.removeFromSuperview()
//                if #available(iOS 10.0, *) {
//                    let generator = UINotificationFeedbackGenerator()
//                    generator.notificationOccurred(.success)
//                }
//            } else
            if !canvasImageView.bounds.contains(view.center) { //Snap the view back to canvasImageView
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.canvasImageView.center
                })
                
            }
        }
    }
    
}

