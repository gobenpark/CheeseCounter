//
//  UserInfoModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct UserInfoModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: Data
    
    struct Data: Codable{
      let access_token: String?
      let addr: String
      let addr1: String
      let addr2: String
      let age: String
      let birth_year: String?
      let created_date: String?
      let fcm_token: String?
      let gender: String
      let id: String?
      let img_url: String
      let is_enable: String?
      let level: String?
      let nickname: String
      let recent_date: String?
      let type: String?
      let version: String?
      
      init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try? values.decode(String.self, forKey: .access_token)
        addr = try values.decode(String.self, forKey: .addr)
        addr1 = try values.decode(String.self, forKey: .addr1)
        addr2 = try values.decode(String.self, forKey: .addr2)
        age = try values.decode(String.self, forKey: .age)
        birth_year = try? values.decode(String.self, forKey: .birth_year)
        created_date = try? values.decode(String.self, forKey: .created_date)
        fcm_token = try? values.decode(String.self, forKey: .fcm_token)
        gender = try values.decode(String.self, forKey: .gender)
        id = try? values.decode(String.self, forKey: .id)
        img_url = try values.decode(String.self, forKey: .img_url)
        is_enable = try? values.decode(String.self, forKey: .is_enable)
        level = try? values.decode(String.self, forKey: .level)
        nickname = try values.decode(String.self, forKey: .nickname)
        recent_date = try? values.decode(String.self, forKey: .recent_date)
        type = try? values.decode(String.self, forKey: .type)
        version = try? values.decode(String.self, forKey: .version)
      }
    }
    
  }
}
