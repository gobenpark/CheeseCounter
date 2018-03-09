//
//  AlertViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif


struct SectionOfAlertData{
  var items: [Item]
}

extension SectionOfAlertData: SectionModelType{
  typealias Item = PushListData.Data
  
  init(original: SectionOfAlertData, items: [Item]) {
    self = original
    self.items = items
  }
}


struct AlertViewModel{
  var items: [Item]
}

extension AlertViewModel: SectionModelType{
  typealias Item = NotiModel.Data
  
  init(original: AlertViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
