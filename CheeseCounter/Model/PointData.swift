//
//  PointData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct PointData: Mappable{
    var code:String?
    var data:Data?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{

        var user_id: String?
        var gold: String?
        var cheese: String?
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.user_id <- map["id"]
            self.gold <- map["gold"]
            self.cheese <- map["cheese"]

        }
    }
}
