//
//  SpinWheelControlDataSource.swift
//  wheelsample
//
//  Created by xiilab on 2018. 1. 3..
//  Copyright © 2018년 bumwoo. All rights reserved.
//

import Foundation

@objc public protocol SpinWheelControlDataSource : NSObjectProtocol {
  
  //Return the number of wedges in the specified SpinWheelControl.
  @objc func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt
  
  //Returns the SpinWheelWedge at the specified index of the SpinWheelControl
  @objc func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge
}
