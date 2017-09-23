//
//  PushListData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 17..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct PushListData: Mappable{
  
  var code: String?
  var data: [Data]?
  
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.code <- map["result.code"]
    self.data <- map["result.data"]
  }
  struct Data:Mappable{
    var id: String?
    var type: String?
    var user_id: String?
    var created_date:String?
    var contents: String?
    var target_id: String?
    var source_id: String?
    var etc: String?
    var summary: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
      self.id <- map["id"]
      self.type <- map["type"]
      self.user_id <- map["user_id"]
      self.created_date <- map["created_date"]
      self.contents <- map["contents"]
      self.target_id <- map["target_id"]
      self.source_id <- map["source_id"]
      self.etc <- map["etc"]
      self.summary <- map["summary"]
    }
  }
}
