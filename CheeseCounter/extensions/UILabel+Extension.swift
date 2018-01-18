//
//  UILabel+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 18..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation


// in Text 사이즈 구하기
extension UILabel{
  func isTruncated() -> Bool {
    if let string = self.text{
      let size: CGRect = string.boundingRect(
        with: CGSize(width: self.frame.width, height: 100)
        , attributes: [NSAttributedStringKey.font: self.font])
      
      if size.height > self.bounds.size.height {
        return true
      }
    }
    return false
  }
  
  func textCount(amount: Int) -> Bool{
    if let linetext = self.text{
      if linetext.count > amount{
        return true
      }
    }
    return false
  }
}
