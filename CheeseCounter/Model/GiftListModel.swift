//
//  GiftListModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

class GiftListModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  
  struct Data: Codable{
    let user_id: String?
    let status: String?
    let contents: String?
    let update_date: String?
    let total_count: String?
    let page_num: String?
    let img_file: String?
    let img_url: String
    let gift_id: String?
    let brand: String?
    let title: String?
    let page_size: String?
    let created_date: String?
    let pin_number: String?
    let img: String?
    let id: String
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      user_id = try? values.decode(String.self, forKey: .user_id)
      status = try values.decode(String.self, forKey: .status)
      pin_number = try? values.decode(String.self, forKey: .pin_number)
      page_size = try? values.decode(String.self, forKey: .page_size)
      gift_id = try? values.decode(String.self, forKey: .gift_id)
      img_file = try? values.decode(String.self, forKey: .img_file)
      page_num = try? values.decode(String.self, forKey: .page_num)
      contents = try? values.decode(String.self, forKey: .contents)
      update_date = try? values.decode(String.self, forKey: .update_date)
      img_url = try values.decode(String.self, forKey: .img_url)
      brand = try? values.decode(String.self, forKey: .brand)
      title = try? values.decode(String.self, forKey: .title)
      created_date = try? values.decode(String.self, forKey: .created_date)
      img = try? values.decode(String.self, forKey: .img)
      total_count = try? values.decode(String.self, forKey: .total_count)
    }
  }
}

