//
//  UIColor+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 10. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

extension UIColor{
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  static func cheeseColor() -> UIColor{
    return UIColor.white
    
  }
}
