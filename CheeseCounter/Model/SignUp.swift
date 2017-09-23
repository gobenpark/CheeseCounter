//
//  SignUp.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 29..
//  Copyright © 2017년 xiilab. All rights reserved.
//



struct SignUp{
  enum genderType{
    case male
    case female
  }
  
  var provisionComple: Bool?
  var nickName: String?
  var gender: genderType?
  var age: String?
  var addr1: String?
  var addr2: String?
  
  init() {
  }
  
  func getParameters() -> [String:String]{
    var parameter = [String:String]()
    parameter["nickname"] = nickName!
    parameter["gender"] = (gender == genderType.male) ? "male" : "female"
    parameter["addr1"] = addr1!
    parameter["addr2"] = addr2!
    parameter["age"] = age!
    return parameter
  }
  
}
