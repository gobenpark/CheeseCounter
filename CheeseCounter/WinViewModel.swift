//
//  WinListModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 12..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct WinViewModel{
  var items: [Item]
}

extension WinViewModel: SectionModelType{
  
  typealias Item = WinListModel.Result.Data
  
  init(original: WinViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
