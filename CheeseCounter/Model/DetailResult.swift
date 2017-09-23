//
//  DetailResult.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct DetailResult: Mappable{
  
  var code: String?
  var data: Data!
  var select_ask: String?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.code <- map["result.code"]
    self.data <- map["result.data"]
    self.select_ask <- map["surveyResultVO.select_ask"]
  }
  
  struct Data: Mappable{
    
    var gender_age:[SubData]!
    var addr:[SubData]!
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
      self.gender_age <- map["gender_age"]
      self.addr <- map["addr"]
      
    }
    
    struct SubData: Mappable{
      var category: String!
      var count: String!
      
      init?(map: Map) {
      }
      mutating func mapping(map: Map) {
        self.category <- map["category"]
        self.count <- map["count"]
      }
      
    }
  }
}
