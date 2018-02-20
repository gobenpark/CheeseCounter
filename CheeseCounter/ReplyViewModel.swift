//
//  ReplyViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

struct ReplyViewModel{
  var items: [Item]
}

extension ReplyViewModel: SectionModelType{
  typealias Item = ReplyModel.Data
  init(original: ReplyViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
