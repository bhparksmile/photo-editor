//
//  PhotoEditor+Crop.swift
//  SmileBaby
//
//  Created by bhpark on 2021/06/08.
//  Copyright © 2021 smilelab. All rights reserved.
//

import UIKit

// MARK: - CropView
extension PhotoEditorViewController: CropViewControllerDelegate {
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        self.setImageView(image: image)
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
