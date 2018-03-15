//
//  QuestionData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 28..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

struct QuestionData {
    var title:String
    var type: String
    var ask1: String
    var ask2: String
    var ask3: String
    var ask4: String
    var hash_tag: String
    var img_status: String
    var is_option: String{
        didSet{
            if is_option == "0"{
                self.option_cut_cheese = "0"
                self.option_set_count = ""
            }
        }
    }
    
    var option_age:String
    var option_addr: String
    var option_gender: String
    var option_cut_cheese: String
    var option_set_count: String
    var limit_date: String
    
    init() {
        self.title = ""
        self.type = "2"
        self.ask1 = ""
        self.ask2 = ""
        self.ask3 = ""
        self.ask4 = ""
        self.hash_tag = ""
        self.img_status = ""
        self.is_option = "0"
        self.option_age = "10,20,30,40,50,60"
        self.option_addr = ""
        self.option_gender = "male,female"
        self.option_cut_cheese = "0"
        self.option_set_count = ""
        self.limit_date = ""
    }
    
    
    func defaultEndDate() -> String{
        let date = Date(timeIntervalSinceNow: 60*60*24*7)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func getAllParamter() -> [String:String]{
        var parameter = [String:String]()
        for (key,value) in Mirror(reflecting: self).children{
            parameter[key ?? ""] = "\(value)"
        }
        return parameter
    }
    
    func defaultParameter() -> [String:String]{
        var parameter = [String:String]()
        for (key,value) in Mirror(reflecting: self).children{
            if let iscontain = key?.contains("option_"){
                if !iscontain{
                    parameter[key ?? ""] = "\(value)"
                }
            }
        }
        return parameter
    }
    
    func isComplete() -> (Bool,String){
        if self.title == ""{
            return (false,"제목을 입력해주세요")
        }
        
        if self.type == "2"{
            if self.ask1 == "" || self.ask2 == ""{
                return (false,"질문을 모두 입력해주세요")
            }
        }else {
            if self.ask1 == "" || self.ask2 == "" || self.ask3 == "" || self.ask4 == ""{
                return (false,"질문을 모두 입력해주세요")
            }
        }
        
        if self.hash_tag == ""{
            return (false,"해시태그를 입력해주세요")
        }
        return (true,"사진 입력해주세요")
    }
    
}
