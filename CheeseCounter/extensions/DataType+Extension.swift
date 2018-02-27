//
//  DataType+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 26..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation


extension Double {
  func roundToPlaces(places:Int) -> Double{
    let divisor = pow(10.0,Double(places))
    return Darwin.round(self * divisor) / divisor
  }
}

extension Int {
  func stringFormattedWithSeparator() -> String  {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
}
