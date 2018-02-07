//
//  RankData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 31..
//  Copyright © 2017년 xiilab. All rights reserved.
//

struct RankModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let data: [Data]
    let code: String
  
    struct Data: Codable{
      let cheese: String
      let img_url: String
      let nickname: String
      let rank: String
      let title: String?
      let user_id: String?
      
      init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cheese = try values.decode(String.self, forKey: .cheese)
        img_url = try values.decode(String.self, forKey: .img_url)
        nickname = try values.decode(String.self, forKey: .nickname)
        rank = try values.decode(String.self, forKey: .rank)
        title = try? values.decode(String.self, forKey: .title)
        user_id = try? values.decode(String.self, forKey: .user_id)
      }
    }
  }
}
