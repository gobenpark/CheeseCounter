//
//  Bundle+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 10. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

extension Bundle{
  class func provisionFromFile(name: String) -> Data{
    guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {return Data()}
    do {
      let data = try Data(contentsOf: path.fileurl)
      return data
    } catch {
      return Data()
    }
  }
}


