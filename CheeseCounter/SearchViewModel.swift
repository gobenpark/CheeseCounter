//
//  SearchViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 29..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct SearchViewModel{
  var items: [Item]
}

extension SearchViewModel: SectionModelType{
  typealias Item = CheeseResultByDate.Data
  init(original: SearchViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
