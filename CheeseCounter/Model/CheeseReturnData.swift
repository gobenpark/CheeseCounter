//
//  CheeseReturnData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 8..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

struct GoldReturnData{
    
    var name: String
    var bank: String
    var account_number: String
    var cash: String
    
    init() {
        self.name = ""
        self.bank = "은행을 선택하세요"
        self.account_number = ""
        self.cash = ""
    }
}
