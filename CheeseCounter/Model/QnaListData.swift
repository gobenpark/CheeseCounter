//
//  QnaList.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct QnaListData: Mappable{
    
    var code:String?
    var data:[Data]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data:Mappable{
        
        var q_id:String?
        var q_title: String?
        var q_contents: String?
        var q_status: String?
        var q_created_date: String?
        var q_nickname: String?
        var a_id: String?
        var a_contents: String?
        var a_created_date: String?
        var isExpand:Bool = false 
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.q_id <- map["q_id"]
            self.q_title <- map["q_title"]
            self.q_contents <- map["q_contents"]
            self.q_status <- map["q_status"]
            self.q_created_date <- map["q_created_date"]
            self.q_nickname <- map["q_nickname"]
            self.a_id <- map["a_id"]
            self.a_contents <- map["a_contents"]
            self.a_created_date <- map["a_created_date"]
        }
    }
}
