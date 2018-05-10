//
//  UserService.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//  123

import Alamofire
import ObjectMapper
import SwiftyJSON
import Firebase
import Moya
import Crashlytics
import FirebaseMessaging
import RxSwift
import RxCocoa

public enum serverType{
  case release
  case test
  
  var url: String{
    switch self {
    case .release:
      return "https://cheesecounter.co.kr/"
    case .test:
      return "http://192.168.1.19:8088"
    }
  }
  
  var imgString: String{
    switch self {
    case .release:
      return "https://cheesecounter.co.kr/uploadFile"
    case .test:
      return "http://192.168.1.19:8088/uploadFile"
    }
  }
}

struct UserService {
  
  #if DEBUG
  static let url = serverType.test.url
  static let imgString = serverType.test.imgString
  #else
  static let url = serverType.release.url
  static let imgString = serverType.release.imgString
  #endif
  
  static var kakao_ID: NSNumber?
  static var isLogin: Bool = false
  static var mainParameter:[String:Any] = [:]
  
  static let dispatchGroup: DispatchGroup = DispatchGroup()
  
  let disposeBag = DisposeBag()
  
  /// 초기 로딩시 프로필정보 가져옴
  //  static func me(_ completion: @escaping (DataResponse<UserResult>) -> Void){
  //    let urlString = "\(url)/auth/loginUser.json"
  //    let manager = Alamofire.SessionManager.default
  //    manager.session.configuration.timeoutIntervalForRequest = 120
  //
  //    kakaoTask()
  //
  //    dispatchGroup.notify(queue: DispatchQueue.main) {
  //      manager.request(urlString,method: .post, parameters: mainParameter)
  //        .validate(statusCode: 200..<400)
  //        .responseJSON { (response) in
  //          let response: DataResponse<UserResult> = response.flatMap{ json in
  //            if let user = Mapper<UserResult>().map(JSONObject: json){
  //              Answers.logLogin(withMethod: "MainLogin", success: true, customAttributes: nil)
  //              isLogin = true
  //              return .success(user)
  //            } else {
  //              Answers.logLogin(withMethod: "MainLogin", success: false, customAttributes: nil)
  //              let error = MappingError(from: json, to: UserResult.self)
  //              return .failure(error)
  //            }
  //          }
  //          completion(response)
  //          sendFcmToken()
  //      }
  //    }
  //  }
  
  static func sendFcmToken(){
    guard let fcmtoken = Messaging.messaging().fcmToken else {return}
    log.info("FCM token : \(fcmtoken)")
    
    _ = CheeseService.provider
      .request(.fcmSender(fcm_token: fcmtoken))
      .filter(statusCode: 200)
      .asObservable()
      .subscribe(onNext:  { _ in
        AppDelegate.instance?.isTokenRefreshed = true
      }, onError: { (err) in
        Crashlytics.sharedInstance().recordError(err)
      })
    }
    
    
    //  static func kakaoTask(){
    //
    //    dispatchGroup.enter()
    //    KOSessionTask.meTask { (result, error) in
    //      guard let result = result else {return}
    //      if let user = result as? KOUser {
    //
    //        self.kakao_ID = user.id
    //        let profile = user.property(forKey: KOUserProfileImagePropertyKey) as? String
    //        mainParameter["img_url"] = profile ?? ""
    //        mainParameter["id"] = user.id
    //        mainParameter["access_token"] = KOSession.shared().accessToken
    //        mainParameter["version"] = "1.0.2i"
    //      }
    //      dispatchGroup.leave()
    //    }
    //  }
    
    /// 닉네임의 중복체크
    static func check(nickname: String, _ completion: @escaping (DataResponse<NickResult>) -> Void) {
      let urlString = "\(url)/auth/checkNickname.json"
      let parameter:[String:String] = ["nickname":nickname]
      let manager = Alamofire.SessionManager.default
      manager.session.configuration.timeoutIntervalForRequest = 120
      
      manager.request(urlString, method: .post, parameters: parameter)
        .validate(statusCode: 200..<400)
        .responseJSON { (response) in
          let response: DataResponse<NickResult> = response.flatMap{ json in
            if let user = Mapper<NickResult>().map(JSONObject: json){
              return .success(user)
            } else {
              let error = MappingError(from: json, to: NickResult.self)
              return .failure(error)
            }
          }
          completion(response)
      }
    }
    
    /// 유저정보 가져오기 (현재 로그인 되어있는 사용자)
    ///
    /// - Parameter completion: 콜백
    static func getMyInfo(_ completion: @escaping (DataResponse<UserResult>) -> Void) {
      let urlString = "\(url)/auth/getMyInfo.json"
      let manager = Alamofire.SessionManager.default
      manager.session.configuration.timeoutIntervalForRequest = 120
      manager.request(urlString, method: .post)
        .validate(statusCode: 200..<400)
        .responseJSON { (response) in
          
          let response: DataResponse<UserResult> = response.flatMap{ json in
            if let user = Mapper<UserResult>().map(JSONObject: json){
              return .success(user)
            } else {
              let error = MappingError(from: json, to: UserResult.self)
              
              return .failure(error)
            }
          }
          completion(response)
      }
    }
    
    static func sessionExpireAction(){
      let alertController = UIAlertController(title: "세션이 만료되어 재로그인 합니다.", message: "", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
        AppDelegate.instance?.reloadRootViewController()
      }))
      AppDelegate.instance?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
