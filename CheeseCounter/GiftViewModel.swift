//
//  GiftViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct GiftViewModel{
  var items: [Item]
}

extension GiftViewModel: SectionModelType{
  
  typealias Item = GiftModel.Result.Data
  
  init(original: GiftViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

