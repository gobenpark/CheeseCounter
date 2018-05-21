//
//  CheeseService.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//
import Foundation

import Alamofire
import ObjectMapper
import SwiftyJSON
import Moya
import RxSwift
import Crashlytics
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

struct CheeseService {
  
  static let version: String = "1.0.5i"
  
  #if DEBUG
  static let provider = MoyaProvider<CheeseCounter>(plugins:[NetworkLoggerPlugin(verbose:true)]).rx
  #else
  static let provider = MoyaProvider<CheeseCounter>().rx
  #endif
  
  
  static func upDateMyPush(parameter:[String:String], _ completion: @escaping (String,String) -> Void){
    let url = "\(UserService.url)/push/updateMyPush.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string
              ,let data = json["result"]["data"].string{
              if (json["code"].string ?? "") == "2001"{
                sessionExpireAction()
              }
              completion(result,data)
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          completion(error.localizedDescription,"error")
        }
    }
  }
  /// # 지역정보 가져오기
  ///
  /// - Parameters:
  ///   - sj: 시는 기본호출 구 는 si 호출 ex) sj:서울특별시 output: 종로구
  ///   - completion: callBack
  
  static func getRegion(_ completion: @escaping (DataResponse<RegionData>) -> Void) {
    let url = "\(UserService.url)/auth/getRegion.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string{
              if result == "2001"{
                sessionExpireAction()
              }
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<RegionData> = response.flatMap{ json in
          if let user = Mapper<RegionData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: RegionData.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  static func getQnaList(_ completion: @escaping (DataResponse<QnaListData>) -> Void){
    let url = "\(UserService.url)/qna/getQnaList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["code"].string{
              if result == "2001"{
                sessionExpireAction()
              }
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }}.responseJSON { (response) in
          let response: DataResponse<QnaListData> = response.flatMap{ json in
            if let user = Mapper<QnaListData>().map(JSONObject: json){
              return .success(user)
            } else {
              let error = MappingError(from: json, to: QnaListData.self)
              return .failure(error)
            }
          }
          completion(response)
    }
  }
  static func getNoticeList(_ completion: @escaping (DataResponse<NoticeData>) -> Void) {
    let url = "\(UserService.url)/notice/getNoticeList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string{
              if result == "2001"{
                sessionExpireAction()
              }else{
                let response: DataResponse<NoticeData> = response.flatMap{ json in
                  if let user = Mapper<NoticeData>().map(JSONObject: json){
                    return .success(user)
                  } else {
                    let error = MappingError(from: json, to: NoticeData.self)
                    return .failure(error)
                  }
                }
                completion(response)
              }
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
    }
  }
  
  
  /// 푸시 데이터 가져오기
  ///
  /// - Parameter completion: 콜백
  static func getMyPush(_ completion: @escaping (DataResponse<PushData>) -> Void){
    let url = "\(UserService.url)/push/getMyPush.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string{
              if result == "2001"{
                sessionExpireAction()
              }
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }}.responseJSON { (response) in
          
          let response: DataResponse<PushData> = response.flatMap{ json in
            if let user = Mapper<PushData>().map(JSONObject: json){
              return .success(user)
            } else {
              let error = MappingError(from: json, to: PushData.self)
              return .failure(error)
            }
          }
          completion(response)
    }
  }
  
  
  
  
  /// dropOut
  ///
  /// - Parameter completion: callBack
  static func insertSecession(_ completion: @escaping (String) -> Void){
    let url = "\(UserService.url)/auth/insertSecession.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string{
              if json["code"] == "2001"{
                sessionExpireAction()
              }
              completion(result)
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          completion(error.localizedDescription)
        }
    }
  }
  
  
  static func deleteSecession(_ completion: @escaping (String) -> Void){
    let url = "\(UserService.url)/auth/deleteSecession.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
            let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string{
              if (json["code"].string ?? "") == "2001"{
                sessionExpireAction()
              }
              completion(result)
            }
          }catch let error{
            log.error(error)
          }
        case .failure(let error):
          completion(error.localizedDescription)
        }
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



