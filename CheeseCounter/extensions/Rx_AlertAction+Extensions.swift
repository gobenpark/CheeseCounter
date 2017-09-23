//
//  Rx_AlertAction+Extensions.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
import Moya
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif


extension ObservableType where E == (AlertType, String){
  func alertViewMapper() -> Observable<UIViewController>{
    return asObservable().flatMap { (data) -> Observable<UIViewController> in
      
      
      let cheeseData = CheeseService.provider.rx
        .request(.getSurveyById(id: data.1.components(separatedBy: ",").first!))
        .asObservable()
        .map(CheeseResultByDate.self)
      
      switch data.0{
      case .cheese_return:
        return Observable.just(QnAViewController())
      case .event:
        return Observable.just(QnAViewController())
      case .notice:
        return Observable.just(NoticeViewController())
      case .qna:
        return Observable.just(QnAViewController())
      case .reply:
        
        let observable = Observable.just(CheeseResultViewController())
        return Observable<UIViewController>.zip(cheeseData, observable, resultSelector: { (data, VC) -> UIViewController in
          VC.cheeseData = data.singleData
          return VC
        })
      case .survey_done:
        let observable = Observable.just(CheeseResultViewController())
        return Observable<UIViewController>.zip(cheeseData, observable, resultSelector: { (data, VC) -> UIViewController in
          VC.cheeseData = data.singleData
          return VC
        })
      case .update:
        return Observable.just(QnAViewController())
      case .answer_survey_done:
        let observable = Observable.just(CheeseResultViewController())
        return Observable<UIViewController>.zip(cheeseData, observable, resultSelector: { (data, VC) -> UIViewController in
          VC.cheeseData = data.singleData
          return VC
        })
      case .reply_empathy:
        let observable = Observable.just(CheeseResultViewController())
        return Observable<UIViewController>.zip(cheeseData, observable, resultSelector: { (data, VC) -> UIViewController in
          VC.cheeseData = data.singleData
          return VC
        })
      }
    }
  }
}
