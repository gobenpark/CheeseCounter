//
//  NotiModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 9..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct NotiModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  
  struct Data: Codable{
    let contents: String
    let created_date: String
    let etc: String
    let page_num: String?
    let page_size: String?
    let source_id: String?
    let summary: String
    let target_id: String
    let type: String?
    let user_id: String
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      contents = try values.decode(String.self, forKey: .contents)
      created_date = try values.decode(String.self, forKey: .created_date)
      etc = try values.decode(String.self, forKey: .etc)
      page_num = try? values.decode(String.self, forKey: .page_num)
      page_size = try? values.decode(String.self, forKey: .page_size)
      source_id = try? values.decode(String.self, forKey: .source_id)
      summary = try values.decode(String.self, forKey: .summary)
      target_id = try values.decode(String.self, forKey: .target_id)
      type = try? values.decode(String.self, forKey: .type)
      user_id = try values.decode(String.self, forKey: .user_id)
    }
  }
}
