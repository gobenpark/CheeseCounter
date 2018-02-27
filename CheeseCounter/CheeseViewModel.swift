//
//  CheeseViewMocel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct CheeseViewModel{
  
  var items: [Item]
}

extension CheeseViewModel: SectionModelType{
  
  typealias Item = MainSurveyList.CheeseData

  init(original: CheeseViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

