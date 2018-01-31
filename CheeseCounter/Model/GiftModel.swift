//
//  GiftModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct GiftModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
    
    
    struct Data: Codable{
      let brand: String
      let buyPoint: String
      let contents: String
      let createdDate: String
      let game1Point: String
      let game2Point: String
      let game3Point: String
      let id: String
      let imgFile: String?
      let imageURL: String?
      let isEnable: String
      let pageNum: String?
      let pageSize: String?
      let title: String
      let totalCount: String?
      let type: String?
      let userID: String?
      
      enum CodingKeys: String,CodingKey{
        case brand
        case buyPoint = "buy_point"
        case contents
        case createdDate = "created_date"
        case game1Point = "game1_point"
        case game2Point = "game2_point"
        case game3Point = "game3_point"
        case id
        case imgFile = "img_file"
        case imageURL = "img_url"
        case isEnable = "is_enable"
        case pageNum = "page_num"
        case pageSize = "page_size"
        case title
        case totalCount = "total_count"
        case type
        case userID = "user_id"
      }
      
      init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brand = try values.decode(String.self, forKey: .brand)
        buyPoint = try values.decode(String.self, forKey: .buyPoint)
        contents = try values.decode(String.self, forKey: .contents)
        createdDate = try values.decode(String.self, forKey: .createdDate)
        game1Point = try values.decode(String.self, forKey: .game1Point)
        game2Point = try values.decode(String.self, forKey: .game2Point)
        game3Point = try values.decode(String.self, forKey: .game3Point)
        id = try values.decode(String.self, forKey: .id)
        imgFile = try? values.decode(String.self, forKey: .imgFile)
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        isEnable = try values.decode(String.self, forKey: .isEnable)
        pageNum = try? values.decode(String.self, forKey: .pageNum)
        pageSize = try? values.decode(String.self, forKey: .pageSize)
        title = try values.decode(String.self, forKey: .title)
        totalCount = try? values.decode(String.self, forKey: .totalCount)
        type = try? values.decode(String.self, forKey: .type)
        userID = try? values.decode(String.self, forKey: .userID)
      }
    }
  }
}
