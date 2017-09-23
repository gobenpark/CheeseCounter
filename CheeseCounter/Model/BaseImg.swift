//
//  BaseImg.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct BaseImg: Mappable{
    
    var code: String?
    var data: [Data]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{
        
        var title: String!
        var img_url: String!
        var id: String!
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.title <- map["title"]
            self.img_url <- map["img_url"]
            self.id <- map["id"]
        }
    }
}
