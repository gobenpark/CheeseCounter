//
//  PointModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 31..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct PointModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: Data
  }
  
  struct Data: Codable{
    let user_id: String?
    let gold: String?
    let cheese: String?
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      user_id = try? values.decode(String.self, forKey: .user_id)
      gold = try? values.decode(String.self, forKey: .gold)
      cheese = try? values.decode(String.self, forKey: .cheese)
    }
  }
}
