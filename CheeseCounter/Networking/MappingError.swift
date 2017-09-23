//
//  MappingError.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

struct MappingError: Error, CustomStringConvertible {

  let description: String

  init(from: Any?, to: Any.Type) {
    self.description = "Failed to map \(String(describing: from)) to \(to)"
  }

}
