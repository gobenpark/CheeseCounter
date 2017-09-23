//
//  RankData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 31..
//  Copyright © 2017년 xiilab. All rights reserved.
//


import ObjectMapper

struct RankData: Mappable{
  
  var code:String?
  var data:Data?
  var datas:[Data]?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.code <- map["result.code"]
    self.data <- map["result.data"]
    self.datas <- map["result.data"]
  }
  
  struct Data: Mappable{
    var img_url: String?
    var nickname: String?
    var cheese: String?
    var rank: String?
    var title: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
      self.img_url <- map["img_url"]
      self.nickname <- map["nickname"]
      self.cheese <- map["cheese"]
      self.rank <- map["rank"]
      self.title <- map["title"]
    }
  }

}
