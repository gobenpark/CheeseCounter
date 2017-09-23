//
//  CheeseResult.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
import RxSwift

struct CheeseResult{
  
  var cheeseData: CheeseResultByDate.Data!
  var resultData: [SurveyResult.Data]?
  
  func getPercent(number: Int) -> Double{
    
    var totalCount = 0.0
    var percent: Double = 0
    
    //총계산
    resultData?.forEach({ (data) in
      guard let count = Double(data.count ?? "") else {return}
      totalCount += count
    })
    
    log.info(totalCount)

    // 퍼센트계산
    resultData?.forEach { (data) in
      let ask = data.select_ask ?? ""
      if ask == "\(number+1)" {
        let count = Double(data.count ?? "") ?? 0
        percent = (count/totalCount) * 100
      }
    }
    return percent
  }
  
  func getType() -> String{
    return self.cheeseData?.type ?? ""
  }
}

