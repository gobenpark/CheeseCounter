//
//  Operators.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 21..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

func + <T>(lhs: [T], rhs: T) -> [T] {
  var copy = lhs
  copy.append(rhs)
  return copy
}
