//
//  UIImage+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 25..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

extension UIImage{
  
  func filledBlendImage(blendMode: CGBlendMode) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(UIColor.white.cgColor)
    context?.setBlendMode(blendMode)
    context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
  static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
}

