//
//  BaseImg.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct BaseImgModel: Codable{
  let result: Result
  
  struct Result: Codable{
    let code: String
    let data: [Data]
  }
  
  struct Data: Codable {
    let title: String
    let img_url: String
    let id: String
  }
}
