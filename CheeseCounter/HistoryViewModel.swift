//
//  HistoryViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxDataSources

struct HistoryViewModel{
  var items: [Item]
}

extension HistoryViewModel: SectionModelType{
  
  typealias Item = HistoryModel.Result.Data
  
  init(original: HistoryViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}



