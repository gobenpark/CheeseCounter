//
//  NoticeData.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 11..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct NoticeData: Mappable{
    
    var code: String?
    var data: [Data]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{
        var id: String?
        var created_date: String?
        var contents: String?
        var title: String?
        var isExpand: Bool = false
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.id <- map["id"]
            self.created_date <- map["created_date"]
            self.contents <- map["contents"]
            self.title <- map["title"]
        }
    }
}


