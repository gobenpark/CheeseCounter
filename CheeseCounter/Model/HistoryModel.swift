//
//  HistoryModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

struct HistoryModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
    
    struct Data: Codable{
      let amount: String
      let created_date: String
      let id: String
      let month: String?
      let summary: String
      let type: String
      let user_id: String
      let year: String?
      
      init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(String.self, forKey: .amount)
        created_date = try values.decode(String.self, forKey: .created_date)
        id = try values.decode(String.self, forKey: .id)
        month = try? values.decode(String.self, forKey: .month)
        summary = try values.decode(String.self, forKey: .summary)
        type = try values.decode(String.self, forKey: .type)
        user_id = try values.decode(String.self, forKey: .user_id)
        year = try? values.decode(String.self, forKey: .year)
      }
    }
  }
}
