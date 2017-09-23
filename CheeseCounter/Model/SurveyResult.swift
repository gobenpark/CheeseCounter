//
//  ServeyResult.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 28..
//  Copyright © 2017년 xiilab. All rights reserved.
//


import ObjectMapper

struct SurveyResult: Mappable{
    
    var code: String?
    var data: [Data]?
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{
        
        var select_ask: String?
        var survay_id: String?
        var count: String?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.select_ask <- map["select_ask"]
            self.survay_id <- map["survay_id"]
            self.count <- map["count"]
            
        }
    }

}
