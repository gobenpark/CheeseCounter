//
//  SpinWheelControlDelegate.swift
//  wheelsample
//
//  Created by xiilab on 2018. 1. 3..
//  Copyright © 2018년 bumwoo. All rights reserved.
//

import Foundation
import UIKit


@objc public protocol SpinWheelControlDelegate {

  //Triggered when the spin wheel has come to rest after spinning.
  @objc optional func spinWheelDidEndDecelerating(spinWheel: SpinWheelControl)
  
  //Triggered at various intervals. The variable radians describes how many radians the spin wheel control has moved since the last time this method was called.
  @objc optional func spinWheelDidRotateByRadians(radians: CGFloat)
  
  @objc optional func spinWheelCurrent(index: Int, temp: CGFloat)
  
  @objc optional func spinStart(velocity: CGFloat)
}
