//
//  UIImage+Size.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/2/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /**
     Suitable size for specific height or width to keep same image ratio
     */
    func suitableSize(heightLimit: CGFloat? = nil,
                             widthLimit: CGFloat? = nil )-> CGSize? {
        
        if let height = heightLimit {
            
            let width = (height / self.size.height) * self.size.width
            
            return CGSize(width: width, height: height)
        }
        
        if let width = widthLimit {
            let height = (width / self.size.width) * self.size.height
            return CGSize(width: width, height: height)
        }
        
        return nil
    }
    
    func suitableSize(limit: CGSize)-> CGSize? {
        let widthRatio = limit.width / self.size.width
        let heightRatio = limit.height / self.size.height
        let ratio = min(widthRatio, heightRatio)
        
        let newWidth = Int(round(self.size.width * ratio))
        let newHeight = Int(round(self.size.height * ratio))
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
}
