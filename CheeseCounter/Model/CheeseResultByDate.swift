//
//  CheeseResultByDate.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct CheeseResultByDate: Mappable {
  
  var code: String?
  var data: [Data]?
  var singleData: Data?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    self.code <- map["result.code"]
    self.data <- map["result.data"]
    self.singleData <- map["result.data"]
  }
  
  struct Data: Mappable {
    var id: String!
    var type: String?
    var created_date: String!
    var userid: String!
    var page_size: String?
    var page_num: String?
    var title: String!
    var main_img_url: String?
    var limit_date: String!
    var option_remain_count: String?
    var ask1: String?
    var ask2: String?
    var ask3: String?
    var ask4: String?
    var ask1_img_url: String?
    var ask2_img_url: String?
    var ask3_img_url: String?
    var ask4_img_url: String?
    var hash_tag: String!
    var total_count: String?
    var user_img_url: String?
    var nickname: String!
    var is_option: String?
    var option_cut_cheese: String?
    var option_set_count: String?
    var recent_reply: String?
    var like_count: String?
    var empathy_count: String?
    var resultData:[SurveyResult.Data]?
    var is_empathy: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
      self.id <- map["id"]
      self.type <- map["type"]
      self.created_date <- map["created_date"]
      self.userid <- map["user_id"]
      self.page_size <- map["page_size"]
      self.page_num <- map["page_num"]
      self.title <- map["title"]
      self.main_img_url <- map["main_img_url"]
      self.limit_date <- map["limit_date"]
      self.option_remain_count <- map["option_remain_count"]
      self.ask1 <- map["ask1"]
      self.ask2 <- map["ask2"]
      self.ask3 <- map["ask3"]
      self.ask4 <- map["ask4"]
      self.ask1_img_url <- map["ask1_img_url"]
      self.ask2_img_url <- map["ask2_img_url"]
      self.ask3_img_url <- map["ask3_img_url"]
      self.ask4_img_url <- map["ask4_img_url"]
      self.hash_tag <- map["hash_tag"]
      self.total_count <- map["total_count"]
      self.user_img_url <- map["user_img_url"]
      self.nickname <- map["nickname"]
      self.is_option <- map["is_option"]
      self.option_cut_cheese <- map["option_cut_cheese"]
      self.option_set_count <- map["option_set_count"]
      self.recent_reply <- map["recent_reply"]
      self.like_count <- map["like_count"]
      self.empathy_count <- map["empathy_count"]
      self.is_empathy <- map["is_empathy"]
    }
  }
}
