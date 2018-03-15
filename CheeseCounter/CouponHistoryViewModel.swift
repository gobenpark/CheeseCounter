//
//  CouponHistoryCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxDataSources

struct CouponHistoryViewModel{
  var items: [Item]
}

extension CouponHistoryViewModel: SectionModelType{
  
  typealias Item = GiftListModel.Data
  
  init(original: CouponHistoryViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
