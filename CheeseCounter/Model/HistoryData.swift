//
//  HistoryData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import ObjectMapper

struct HistoryData: Mappable {
    
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
        var type: String?
        var created_date: String?
        var user_id: String?
        var amount: String?
        var summary: String?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.id <- map["id"]
            self.type <- map["type"]
            self.created_date <- map["created_date"]
            self.user_id <- map["user_id"]
            self.amount <- map["amount"]
            self.summary <- map["summary"]
        }
    }
}
