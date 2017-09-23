//
//  DataParameter.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 22..
//  Copyright © 2017년 xiilab. All rights reserved.
//

struct DataParameter{
    
    var index1 = "none"
    var index2 = "none"
    var index3 = "none"
    var index4 = "none"
    
    var file1: Data?
    var file2: Data?
    var file3: Data?
    var file4: Data?
    
    
    mutating func getImgStatus() -> String{
        parameterSetting()
        return "\(index1),\(index2),\(index3),\(index4)"
    }
    
    mutating func parameterSetting(){
        var count = 0
        if file1 != nil {
            index1 = "\(count)"
            count += 1
        }
        
        if file2 != nil {
            index2 = "\(count)"
            count += 1
        }
        
        if file3 != nil {
            index3 = "\(count)"
            count += 1
        }
        
        if file4 != nil {
            index4 = "\(count)"
            count += 1
        }
    }
    
    func getDataParameter() -> [Data] {
        var data: [Data] = []
        
        if file1 != nil {
            data.append(file1!)
        }
        if file2 != nil {
            data.append(file2!)
        }
        if file3 != nil {
            data.append(file3!)
        }
        if file4 != nil {
            data.append(file4!)
        }
        
        return data
    }
    
    
    mutating func type(number:Int){
        if number == 2{
            self.file3 = nil
            self.file4 = nil
            self.index3 = "none"
            self.index4 = "none"
        }
    }
    
    func isComplete(type:String) -> (Bool,String){
        if type == "2"{
            if self.index1 == "none" || self.index2 == "none"{
                return (false,"사진을 모두 선택해주세요")
            }
        }else{
            if self.index1 == "none" ||
            self.index2 == "none" ||
            self.index3 == "none" ||
                self.index4 == "none" {
                return (false,"사진을 모두 선택해주세요")
            }
        }
        return (true,"완료")
    }
}
