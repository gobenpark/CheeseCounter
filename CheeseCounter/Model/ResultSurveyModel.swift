//
//  ResultSurveyModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 11. 22..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation


struct ResultSurveyModel: Codable {
  var result: Result
  
  struct Result: Codable {
    var code: String
    var data: Data?
  }
  
  struct Data: Codable {
    var addr: [DataType]
    var age: [DataType]
    var gender: [DataType]
    var gender_age: [DataType]

  }
  
  struct DataType: Codable {
    var category: String
    var count: String
  }
}
