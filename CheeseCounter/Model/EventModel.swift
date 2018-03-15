//
//  EventModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct EventModel: Codable{
    
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  
  struct Data: Codable {
    let contents: String
    let end_date: String
    let id: String
    let img_file: String?
    let img_url: String?
    let page_num: String?
    let page_size: String?
    let start_date: String
    let survey_id: String
    let title: String
    let tooltip: String
    let total_count: String?
    let type: String
    var isExpand: Bool = false
    
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      contents = try values.decode(String.self, forKey: .contents)
      end_date = try values.decode(String.self, forKey: .end_date)
      id = try values.decode(String.self, forKey: .id)
      img_file = try? values.decode(String.self, forKey: .img_file)
      img_url = try? values.decode(String.self, forKey: .img_url)
      page_num = try? values.decode(String.self, forKey: .page_num)
      page_size = try? values.decode(String.self, forKey: .page_size)
      start_date = try values.decode(String.self, forKey: .start_date)
      survey_id = try values.decode(String.self, forKey: .survey_id)
      title = try values.decode(String.self, forKey: .title)
      tooltip = try values.decode(String.self, forKey: .tooltip)
      total_count = try? values.decode(String.self, forKey: .total_count)
      type = try values.decode(String.self, forKey: .type)
    }
  }
}
