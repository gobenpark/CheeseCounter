//
//  ReplyList.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct ReplyList: Mappable{
    
    var code: String?
    var data: [Data]?
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{
        
        var id: String!
        var created_date: String!
        var img_url: String!
        var nickname: String!
        var user_id: String!
        var survey_id: String!
        var parent_id: String?
        var contents: String!
        var like_count: String?
        var is_like: String?
        
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.id <- map["id"]
            self.created_date <- map["created_date"]
            self.nickname <- map["nickname"]
            self.img_url <- map["img_url"]
            self.user_id <- map["user_id"]
            self.survey_id <- map["survey_id"]
            self.parent_id <- map["parent_id"]
            self.contents <- map["contents"]
            self.is_like <- map["is_like"]
            self.like_count <- map["like_count"]
        }
    }
    
}

