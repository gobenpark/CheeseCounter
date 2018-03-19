//
//  BaseImageViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxDataSources

struct BaseImageViewModel{
  var items: [Item]
}

extension BaseImageViewModel: SectionModelType{
  
  typealias Item = BaseImgModel.Data
  
  init(original: BaseImageViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}


