//
//  EventViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxDataSources

struct EventViewModel{
  var items: [Item]
}

extension EventViewModel: SectionModelType{
  
  typealias Item = EventModel.Data
  
  init(original: EventViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

