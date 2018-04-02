//
//  ReplyList.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct ReplyModel: Codable{
  var result: Result
  
  struct Result: Codable{
    let code: String
    var data: [Data]
  }
  
  struct Data: Codable{
    let id: String
    let created_date: String
    let img_url: String
    let user_id: String
    let survey_id: String
    let parent_id: String //0이면 댓글
    let contents: String
    let like_count: String
    let is_like: String
    let nickname: String
    
    // 앱에서 설정
    var hasReply: Bool
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      created_date = try values.decode(String.self, forKey: .created_date)
      img_url = try values.decode(String.self, forKey: .img_url)
      user_id = try values.decode(String.self, forKey: .user_id)
      survey_id = try values.decode(String.self, forKey: .survey_id)
      parent_id = try values.decode(String.self, forKey: .parent_id)
      contents = try values.decode(String.self, forKey: .contents)
      like_count = try values.decode(String.self, forKey: .like_count)
      is_like = try values.decode(String.self, forKey: .is_like)
      nickname = try values.decode(String.self, forKey: .nickname)
      hasReply = false
    }
  }
}
