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
  import RxOptional
#endif

enum AlertType{
  case notice
  case update
  case event
  case reply
  case survey_done
  case gold_return
  case qna
  case recommend
  case answer_survey_done
  case reply_empathy
  
  var typeString: String{
    get{
      switch self {
      case .notice:
        return " 공지사항 "
      case .update:
        return " 업데이트 "
      case .event:
        return " 이벤트 "
      case .reply:
        return " 댓글 "
      case .survey_done:
        return " 질문등록만료 "
      case .gold_return:
        return " 골드환급 "
      case .qna:
        return " 답변 "
      case .answer_survey_done:
        return " 응답질문만료 "
      case .reply_empathy:
        return " 댓글공감 "
      case .recommend:
        return " 추천참여 "
      }
    }
  }
}

extension String{
  func convertAlertType() -> AlertType?{
    switch self{
    case "notice":
      return .notice
    case "update":
      return .update
    case "event":
      return .event
    case "reply":
      return .reply
    case "survey_done":
      return .survey_done
    case "gold_return":
      return .gold_return
    case "qna":
      return .qna
    case "recommend":
      return .recommend
    case "answer_survey_done":
      return .answer_survey_done
    case "reply_empathy":
      return .reply_empathy
    default:
      return nil
    }
  }
}


extension ObservableType where E == (AlertType, String){
  func alertViewMapper() -> Observable<UIViewController>{
    return asObservable().flatMap { (data) -> Observable<UIViewController> in
      
      let cheeseData = CheeseService.provider
        .request(.getSurveyByIdV2(id: data.1.components(separatedBy: ",").first!))
        .filter(statusCode: 200)
        .map(MainSurveyList.self)
        .map{$0.result.data.first}
        .asObservable()
        .filterNil()
      
      switch data.0{
      case .gold_return:
        return Observable.just(UIViewController())
      case .event:
        return Observable.just(CounterEventViewController())
      case .notice:
        return Observable.just(NoticeViewController())
      case .qna:
        return Observable.just(MyInquireViewController())
      case .recommend:
        return Observable.just(MypageNaviViewController(initialPage: 1))
      case .reply:
        return cheeseData.map{ReplyViewController(model: $0)}
      case .survey_done:
        return cheeseData.map{ReplyViewController(model: $0)}
      case .update:
        return Observable.just(NoticeViewController())
      case .answer_survey_done:
        return cheeseData.map{ReplyViewController(model: $0)}
      case .reply_empathy:
        return cheeseData.map{ReplyViewController(model: $0)}
      }
    }
  }
}

