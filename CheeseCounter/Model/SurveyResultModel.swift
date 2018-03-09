//
//  SurveyResultModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 9..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct SurveyResultModel: Codable{
  let result: Result
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  struct Data: Codable{
    let survey_id: String
    let user_id: String
    let created_date: String?
    let select_ask: String
    let addr: String?
    let nickname: String?
    let count: String
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      survey_id = try values.decode(String.self, forKey: .survey_id)
      user_id = try values.decode(String.self, forKey: .user_id)
      created_date = try? values.decode(String.self, forKey: .created_date)
      select_ask = try values.decode(String.self, forKey: .select_ask)
      addr = try? values.decode(String.self, forKey: .addr)
      nickname = try? values.decode(String.self, forKey: .nickname)
      count = try values.decode(String.self, forKey: .count)
    }
  }
}
