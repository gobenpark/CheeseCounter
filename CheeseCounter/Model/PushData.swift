//
//  PushData.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 16..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct PushData: Mappable{
  
  var code: String?
  var data: Data!
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.code <- map["result.code"]
    self.data <- map["result.data"]
  }
  
  struct Data: Mappable{
    var is_contents:String!
    var is_survey_done:String!
    var is_reply: String!
    var is_gold_return: String!
    var is_notice: String!
    var is_update: String!
    var is_qna: String!
    var is_event: String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
      self.is_contents <- map["is_contents"]
      self.is_notice <- map["is_notice"]
      self.is_update <- map["is_update"]
      self.is_event <- map["is_event"]
      self.is_reply <- map["is_reply"]
      self.is_survey_done <- map["is_survey_done"]
      self.is_gold_return <- map["is_gold_return"]
      self.is_qna <- map["is_qna"]
    }
  }
}



