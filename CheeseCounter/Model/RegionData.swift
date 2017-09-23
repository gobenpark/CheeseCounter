//
//  RegionData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper

struct RegionData: Mappable{
    
    var code: String?
    var data: [Data]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.data <- map["result.data"]
    }
    
    struct Data: Mappable{
        var gu: String?
        var si: String?
        var id: String?
        var isSelect: Bool = true
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.gu <- map["gu"]
            self.si <- map["si"]
            self.id <- map["id"]
        }
        
    }
}
