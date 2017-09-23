//
//  OneTimeCheeseData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
import ObjectMapper

struct OneTimeCheeseData: ImmutableMappable {
  
  var code: String
  var id: String?
  var type: String
  var is_enable: String?
  var nickname: String?
  var img_status: String?
  var img_file: String?
  var ask1_img_url: String?
  var ask2_img_url: String?
  var ask3_img_url: String?
  var ask4_img_url: String?
  var is_option: String
  var option_cut_cheese: String?
  var option_set_count: String?
  var page_num: String?
  var total_count: String
  var title: String
  var user_id: String
  var search: String?
  var empathy_count: String
  var page_size: String?
  var main_img_url: String?
  var created_date: Date
  var limit_date: Date
  var option_gold: String?
  var option_age: String?
  var option_addr: String?
  var option_gender: String?
  var ask1: String?
  var ask2: String?
  var ask3: String?
  var ask4: String?
  var hash_tag: String?
  
  init(map: Map) throws {
    self.code            = try map.value("result.code")
    self.id              = try map.value("data.id")
    self.type            = try map.value("result.data.type")
    self.is_enable       = try map.value("result.data.is_enable")
    self.nickname        = try map.value("result.data.nickname")
    self.img_status      = try map.value("result.data.img_status")
    self.img_file        = try map.value("result.data.img_file")
    self.ask1_img_url    = try map.value("result.data.ask1_img_url")
    self.ask2_img_url    = try map.value("result.data.ask2_img_url")
    self.ask3_img_url     = try map.value("result.data.ask3_img_url")
    self.ask4_img_url     = try map.value("result.data.ask4_img_url")
    self.is_option        = try map.value("result.data.is_option")
    self.option_cut_cheese = try map.value("result.data.option_cut_cheese")
    self.option_set_count = try map.value("result.data.option_set_count")
    self.page_num         = try map.value("result.data.page_num")
    self.total_count      = try map.value("result.data.total_count")
    self.title            = try map.value("result.data.title")
    self.user_id          = try map.value("result.data.user_id")
    self.search           = try map.value("result.data.search")
    self.empathy_count    = try map.value("result.data.empathy_count")
    self.page_size        = try map.value("result.data.page_size")
    self.main_img_url     = try map.value("result.data.main_img_url")
    self.created_date     = try map.value("result.data.created_date")
    self.limit_date       = try map.value("result.data.limit_date")
    self.option_gold      = try map.value("result.data.option_gold")
    self.option_age       = try map.value("result.data.option_age")
    self.option_addr      = try map.value("result.data.option_addr")
    self.option_gender    = try map.value("result.data.option_gender")
    self.ask1             = try map.value("result.data.ask1")
    self.ask2             = try map.value("result.data.ask2")
    self.ask3             = try map.value("result.data.ask3")
    self.ask4             = try map.value("result.data.ask4")
    self.hash_tag         = try map.value("result.data.hash_tag")
  }
  
}
