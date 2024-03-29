//
//  URLNavigationMap.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 8. 17..
//  Copyright © 2017년 xiilab. All rights reserved.
//
import URLNavigator
import AnyDate
import Moya

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxOptional
#endif

enum openType{
  case url(isEnd: Bool)
  case search
  case normal
}

struct OpenData{
  var openType: openType
  var data: CheeseResultByDate.Data?
  var isLogin: Bool
}

struct URLNavigationMap{
  
  static private let dispatchGroup = DispatchGroup()
  static private(set) var cheeseData: CheeseResultByDate.Data?
  static let navigator = Navigator()
  let key: String
  let provider = MoyaProvider<CheeseCounter>().rx
  let disposeBag = DisposeBag()
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    return formatter
  }()
  
  init(key: String) {
    self.key = key
  }
  
  func open(url: URL){
    
    
    let id = url.queryParameters[self.key,default:""]
    
    let CheeseObservable = provider.request(.getSurveyById(id: id))
      .asObservable()
      .map(CheeseResultByDate.self)
      .share(replay: 1)
    
    
    CheeseObservable.subscribe { (event) in
    }.disposed(by: disposeBag)
    
    
    CheeseObservable.subscribe { (event) in
    }.disposed(by: disposeBag)
    
  }

  private static func checkSurveyLive(data: CheeseResultByDate.Data?){
    guard let date = data?.limit_date else {return}
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    guard let limitTime = ZonedDateTime.parse(date, formatter: dateFormatter) else {return}
    
    // 유효기간 만료
    if limitTime.until(endDateTime: ZonedDateTime(), component: .day) <= 0{
      self.confirmLogins(openType: .url(isEnd: true),data: data)
    }
    //유효기간 남음
    else {
      self.confirmLogins(openType: .url(isEnd: false),data: data)
    }
  }
  
  private static func confirmLogins(openType: openType, data: CheeseResultByDate.Data?){
//    switch KOSession.shared().isOpen(){
//    case false:
//      let data = OpenData(openType: openType, data: data, isLogin: false)
//      let cheeseVC = CheeseSelectedViewController(openData: data)
//      Navigator.present(cheeseVC)
//
//    case true:
//      if UserService.isLogin{
//        let data = OpenData(openType: openType, data: data, isLogin: true)
//        let cheeseVC = CheeseSelectedViewController(openData: data)
//        Navigator.push(cheeseVC)
//      }else{
        //로그인이 안되어있는 상황
        // isenable이 0 이거나 login 루틴진행중
        //        NotificationCenter.default.addObserver(self, selector: #selector(splashEndAction(_:)), name: NSNotification.Name(rawValue: "splashEnd"), object: nil)
//      }
    //    }
  }
}

