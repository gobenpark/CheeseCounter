//
//  CanReplyViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import SwiftyJSON
import Toaster
import XLPagerTabStrip

final class AnswerableCheeseViewController: CheeseViewController {
  
  override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "응답 가능 질문")
  }
  
  override func requestSurveyList(reload: Bool) -> Observable<CheeseViewModel> {
    let id = reload ? "" : (dataSources.sectionModels.last?.items.last?.id ?? "")
    
    return CheeseService.provider.request(.getAvailableSurveyListV2(id: id))
      .filter(statusCode: 200)
      .map(MainSurveyList.self)
      .map {CheeseViewModel(items: $0.result.data)}
      .asObservable()
  }

}

