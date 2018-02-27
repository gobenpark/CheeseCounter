//
//  WinListModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

struct WinListModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  
  struct Data: Codable{
    let gift_id: String
    let id: String
    let img_url: String
    let nickname: String
    let update_date: String
    let user_id: String
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      gift_id = try values.decode(String.self, forKey: .gift_id)
      id = try values.decode(String.self, forKey: .id)
      img_url = try values.decode(String.self, forKey: .img_url)
      nickname = try values.decode(String.self, forKey: .nickname)
      update_date = try values.decode(String.self, forKey: .update_date)
      user_id = try values.decode(String.self, forKey: .user_id)
    }
  }
}
