//
//  SurveyDetailViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 11. 22..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif


struct SurveyDetailViewModel{
  var items: [ResultSurveyModel]
}

extension SurveyDetailViewModel: SectionModelType{
  typealias Item = ResultSurveyModel
  
  init(original: SurveyDetailViewModel, items: [ResultSurveyModel]) {
    self = original
    self.items = items
  }
}
