//
//  Nick.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper


struct NickResult: Mappable {
    
    var code: String?
    var count: Int?
    
    
    public init?(map: Map) {
    }

    
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public mutating func mapping(map: Map) {
        self.code <- map["result.code"]
        self.count <- map["result.data.count"]
    }

}
