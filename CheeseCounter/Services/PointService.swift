//
//  PointService.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Alamofire
import ObjectMapper
import SwiftyJSON
import Moya

struct PointService {
  
  static let provider = MoyaProvider<CheeseCounter>()
  
  static func getMyPoint(_ completion: @escaping (DataResponse<PointData>) -> Void){
    let url = "\(UserService.url)/point/getMyPoint.json"
    Alamofire.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<PointData> = response.flatMap{ json in
          if let user = Mapper<PointData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: PointData.self)
            
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  static func getMyPointHistory(parameter:[String:String],_ completion: @escaping (DataResponse<HistoryData>) -> Void){
    let url = "\(UserService.url)/point/getMyPointHistory.json"
    Alamofire.request(url, method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<HistoryData> = response.flatMap{ json in
          if let user = Mapper<HistoryData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: HistoryData.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 치즈 환급
  ///  1. name: 박범우
  ///  2. bank: 은행명
  ///  3. account_number:210-23....
  ///  4. cash: 20000
  /// - Parameters:
  ///   - parameter:
  ///   - completion: 콜백
  static func insertGoldReturn(parameter:[String:String],_ completion: @escaping (String,String) -> Void) {
    let url = "\(UserService.url)/auth/insertGoldReturn.json"
    Alamofire.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          do{
          let json = try JSON(data: response.data!)
            if let result = json["result"]["code"].string
              ,let data = json["result"]["data"].string{
              if result == "2001"{
                sessionExpireAction()
              }
              completion(result,data)
            }
          }catch let error{
            print(error)
          }
        
          
        case .failure(let error):
          completion(error.localizedDescription,"error")
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
  
  static func getMyRank(_ completion: @escaping (DataResponse<RankData>) -> Void){
    let url = "\(UserService.url)/rank/getMyRank.json"
    Alamofire.request(url, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<RankData> = response.flatMap{ json in
          if let user = Mapper<RankData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: HistoryData.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  static func getTopRankList(_ completion: @escaping (DataResponse<RankData>) -> Void){
    let url = "\(UserService.url)/rank/getTopRankList.json"
    Alamofire.request(url, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<RankData> = response.flatMap{ json in
          if let user = Mapper<RankData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: HistoryData.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
}


