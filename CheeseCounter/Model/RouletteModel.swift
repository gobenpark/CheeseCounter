//
//  RouletteModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 26..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct RouletteModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: Data
    
    struct Data: Codable{
      let gift_id: String?
      let id: String?
      let level: String?
      let p: String?
      let pattern1: String?
      let pattern2: String?
      let pattern3: String?
      let pattern4: String?
      let ra: String?
      let re: String?
      let result1: String?
      let result2: String?
      let result3: String?
      let result4: String?
      let s: String?
      let status: String?
      let user_id: String?
      let created_date: String?
      
      
      init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gift_id = try? values.decode(String.self, forKey: .gift_id)
        id = try? values.decode(String.self, forKey: .id)
        level = try? values.decode(String.self, forKey: .level)
        p = try? values.decode(String.self, forKey: .p)
        pattern1 = try? values.decode(String.self, forKey: .pattern1)
        pattern2 = try? values.decode(String.self, forKey: .pattern2)
        pattern3 = try? values.decode(String.self, forKey: .pattern3)
        pattern4 = try? values.decode(String.self, forKey: .pattern4)
        ra = try? values.decode(String.self, forKey: .ra)
        re = try? values.decode(String.self, forKey: .re)
        result1 = try? values.decode(String.self, forKey: .result1)
        result2 = try? values.decode(String.self, forKey: .result2)
        result3 = try? values.decode(String.self, forKey: .result3)
        result4 = try? values.decode(String.self, forKey: .result4)
        s = try? values.decode(String.self, forKey: .s)
        status = try? values.decode(String.self, forKey: .status)
        user_id = try? values.decode(String.self, forKey: .user_id)
        created_date = try? values.decode(String.self, forKey: .created_date)
      }
    }
  }
}

