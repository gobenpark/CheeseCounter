//
//  Degrees+MathMethods.swift
//  wheelsample
//
//  Created by xiilab on 2018. 1. 3..
//  Copyright © 2018년 bumwoo. All rights reserved.
//

import Foundation
import UIKit

extension Degrees {
  
  var toRadians: Radians {
    return self * CGFloat.pi / 180
  }
}


extension Radians{
  var toDegrees: Degrees{
    return self * (180 / CGFloat.pi)
  }
}
