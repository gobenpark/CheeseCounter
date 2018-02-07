//
//  RankViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxDataSources

struct RankViewModel{
  var header: String
  var items: [Item]
}

extension RankViewModel: SectionModelType{

  typealias Item = RankModel.Result.Data
  
  init(original: RankViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

