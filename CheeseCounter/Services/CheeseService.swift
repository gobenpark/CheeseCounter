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


struct CheeseService {
  
  static let provider = MoyaProvider<CheeseCounter>()
  
  static func dateList(parameter:[String:String],_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getSurveyListByDate.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON(completionHandler: { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          Crashlytics.sharedInstance().recordError(error)
        }
      })
      .responseJSON { (response) in
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  /// 메인 리스트 받아옴
  ///
  /// - Parameter completion: 콜백메소드
  static func mainList(_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getSurveyList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 10
    manager.request(url)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          Crashlytics.sharedInstance().recordError(error)
        }
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  /// 데이터 업로드
  ///- parameter parameter: post 파라메터
  ///- parameter dataParameter: 데이터 파라메터
  static func dataUpload(parameter:[String:String],dataParameter:DataParameter,_ completion: @escaping (String,String) -> Void){
    var count = 0
    var urlString = UserService.url+"/survey/insertSurvey.json?"
    
    for (key,value) in parameter {
      if key != "option_addr"{
        urlString = urlString + "\(key)=\(value.encodeUrl())"
        if count != parameter.count - 1{
          urlString = urlString + "&"
          count += 1
        }
      }
    }
    
    Alamofire.upload(multipartFormData: { multipartFormData in
      if parameter["is_option"] == "1"{
        multipartFormData.append((parameter["option_addr"]?.data(using: .utf8))!, withName: "option_addr")
      }
      for value in dataParameter.getDataParameter() {
        multipartFormData.append(value, withName: "img_file", fileName: "jpg", mimeType: "image/jpeg")
      }},
                     
                     to: urlString,
                     method: .post,
                     encodingCompletion: { result in
                      
                      switch result {
                      case .success(let result, _, _):
                        result.validate(statusCode: 200..<400)
                          .responseJSON(completionHandler: { (response) in
                            let json = JSON(data: response.data!)
                            if let result = json["result"]["code"].string
                              ,let data = json["result"]["data"].string{
                              if result == "2001"{
                                sessionExpireAction()
                              }
                              
                              completion(result,data)
                            }
                          })
                        
                      case .failure(let encodingError):
                        Crashlytics.sharedInstance().recordError(encodingError)
                      }
    })
  }
  
  
  /// # 설문 상세결과
  /// ## 선택한문항,설문아이디, 득표수가 반환됨
  /// - Parameters:
  ///   - surveyId: 해당 설문 아이디
  ///   - completion: 콜백 메소드
  static func survayResult(surveyId:String, _ completion: @escaping (DataResponse<SurveyResult>) -> Void){
    let url = "\(UserService.url)/survey/getSurveyResult.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: ["survey_id":surveyId])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          Crashlytics.sharedInstance().recordError(error)
        }
        let response: DataResponse<SurveyResult> = response.flatMap{ json in
          if let user = Mapper<SurveyResult>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: SurveyResult.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 설문 응답을 등록
  ///
  /// - Parameters:
  ///   - surveyId: 설문 아이디
  ///   - select: 몇번을 체크할건지
  ///   - completion: 콜백메소드
  static func insetSurveyResult(surveyId:String,select:Int,_ completion: @escaping (String) -> Void){
    let url = "\(UserService.url)/survey/insertSurveyResult.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    manager.request(url,method: .post, parameters: ["survey_id":surveyId,"select_ask":"\(select)"])
      .validate(statusCode: 200..<400)
      .responseJSON{ (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          Crashlytics.sharedInstance().recordError(error)
        }
        
        switch response.result {
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
            completion(result)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
    }
  }
  
  
  /// 설문 댓글리스트를 가져온다
  ///
  /// - Parameters:
  ///   - surveyId: 해당 설문 아이디
  ///   - completion: 콜백받을 메소드 등록
  static func getReplyList(surveyId:String,_ completion: @escaping (DataResponse<ReplyList>) -> Void){
    let url = "\(UserService.url)/reply/getReplyList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: ["survey_id":surveyId])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          print(error)
        }
        let response: DataResponse<ReplyList> = response.flatMap{ json in
          if let user = Mapper<ReplyList>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: ReplyList.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 댓글을 등록
  ///
  /// - Parameters:
  ///   - parameter: 파라메터에는 여러가지가 들어감
  ///   - completion: 콜백메소드
  static func insertReply(parameter:[String:String],_ completion: @escaping (String,String) -> Void) {
    let url = "\(UserService.url)/reply/insertReply.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    
    
//    provider.request(.insertReply(parameter: parameter)) { (result) in
//      switch result{
//      case .success(let moyaResponse):
//        let data = moyaResponse.data
//        let statusCode = moyaResponse.statusCode
//        
//        let json = JSON(data: data)
//        if let result = json["code"].string{
//          print(result)
//        }
//        
//      case .failure(let error):
//        print(error)
//      }
//    }
    
    
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if let data = json["result"]["data"].string{
              if result == "2001"{
                sessionExpireAction()
              }
              completion(result,data)
            }
            completion(result,"success")
          }
        case .failure(let error):
          completion(error.localizedDescription,"error")
        }
    }
  }
  
  static func deleteReply(id: String, _ completion: @escaping (String,String) -> Void){
    let url = "\(UserService.url)/reply/deleteReply.json"
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: ["id":id])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string
            ,let data = json["result"]["data"].string{
            if result == "2001"{
              sessionExpireAction()
            }
            completion(result,data)
          }
        case .failure(let error):
          completion(error.localizedDescription,"error")
        }
    }
  }
  
  
  /// Base 이미지를 가져옴
  ///
  /// - Parameter completion: 콜백 메소드
  static func getBaseImg(_ completion: @escaping (DataResponse<BaseImg>) -> Void) {
    let url = "\(UserService.url)/baseImg/getBaseImgList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<BaseImg> = response.flatMap{ json in
          if let user = Mapper<BaseImg>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: BaseImg.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 설문 일자별 리스트 구성: 일반
  ///
  /// - Parameters:
  ///   - page_num: 페이지 넘버
  ///   - completion: 콜백 메소드
  static func getSurveyListByDate(parameter:[String:String],_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getSurveyListByDate.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post,parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 설문 옵션에 대한 리스트 : 유료리스트
  ///
  /// - Parameters:
  ///   - page_num: 페이지 넘버
  ///   - completion: 콜백 메소드
  static func getSurveyListByOption(page_num: String,_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getSurveyListByOption.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post,parameters: ["page_num":page_num])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
         log.error(error.localizedDescription)
        }
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 설문 상세결과 더보기
  ///
  /// - Parameters:
  ///   - parameter: survey_id , select_ask
  ///   - completion: 콜백 메소드
  static func getDetailResult(parameter:[String:String],_ completion: @escaping (DataResponse<DetailResult>) -> Void){
    let url = "\(UserService.url)/survey/getDetailResult.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<DetailResult> = response.flatMap{ json in
          if let user = Mapper<DetailResult>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: DetailResult.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 질문 리스트 가져오기
  ///
  /// - Parameters:
  ///   - pageNum: 페이지 번호
  ///   - completion: 콜벡 메소드
  static func getMyRegSurveyList(paging:Paging ,_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getMyRegSurveyList.json"
    
    var pageNumber:Int = 0
    switch paging {
    case .refresh:
      break
    case .next(let pageNum):
      pageNumber = pageNum+1
    }
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post, parameters: ["page_num":"\(pageNumber)"])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 응답리스트 가져오기
  ///
  /// - Parameters:
  ///   - pageNum: 페이지 넘버
  ///   - completion: 콜백 메소드
  static func getMyAnswerSurveyList(paging: Paging,_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/survey/getMyAnswerSurveyList.json"
    
    var pageNumber:Int = 0
    switch paging {
    case .refresh:
      break
    case .next(let pageNum):
      pageNumber = pageNum + 1
    }
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post, parameters: ["page_num":"\(pageNumber)"])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
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
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
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
  
  
  /// 공지사항 가져오기
  ///
  /// - Parameter completion: 콜백
  static func getNoticeList(_ completion: @escaping (DataResponse<NoticeData>) -> Void) {
    let url = "\(UserService.url)/notice/getNoticeList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
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
        case .failure(let error):
          log.error(error.localizedDescription)
        }
    }
  }
  
  /// 푸시 리스트
  ///
  /// - Parameter completion: 콜백
  static func getMyNotifications(paging: Paging,_ completion: @escaping (DataResponse<PushListData>) -> Void) {
    let url = "\(UserService.url)/push/getMyNotification.json"
    
    var pageNumber:Int = 0
    switch paging {
    case .refresh:
      break
    case .next(let pageNum):
      pageNumber = pageNum + 1
    }
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 8
    
    manager.request(url, method: .post,parameters: ["page_num":"\(pageNumber)"])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
        let response: DataResponse<PushListData> = response.flatMap{ json in
          if let user = Mapper<PushListData>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: PushListData.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  
  /// 공감리스트 가져오기
  ///
  /// - Parameters:
  ///   - page_num: 페이징
  ///   - completion: 콜백
  static func getEmpathyList(paging: Paging,_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    let url = "\(UserService.url)/empathy/getEmpathyList.json"
    
    var pageNumber:Int = 0
    switch paging {
    case .refresh:
      break
    case .next(let pageNum):
      pageNumber = pageNum + 1
    }
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post,parameters: ["page_num":"\(pageNumber)"])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }}.responseJSON { (response) in
          let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
            if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
              return .success(user)
            } else {
              let error = MappingError(from: json, to: CheeseResultByDate.self)
              return .failure(error)
            }
          }
          completion(response)
    }
    
  }
  
  
  /// 설문 공감버튼 클릭
  ///
  /// - Parameters:
  ///   - id: 설문아이디
  ///   - completion: 콜백
  static func insertEmpathy(id: String, _ completion: @escaping (String,String) -> Void){
    let url = "\(UserService.url)/empathy/insertEmpathy.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: ["id":id])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string
            ,let data = json["result"]["data"].string{
            if result == "2001"{
              sessionExpireAction()
            }
            completion(result,data)
          }
        case .failure(let error):
          completion(error.localizedDescription,"error")
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
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
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
  
  /// 댓글 좋아요
  /// 1. reply_id : 4
  /// 2. survey_id : 1
  /// - Parameters:
  ///   - parameter: 파라메터
  ///   - completion: 콜백
  static func insertLike(parameter:[String:String], _ completion: @escaping (String) -> Void){
    let url = "\(UserService.url)/reply/insertLike.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            
            if (json["code"].string ?? "") == "2001"{
              sessionExpireAction()
            }
            completion(result)
          }
          
        case .failure(let error):
          completion(error.localizedDescription)
        }
    }
  }
  
  
  /// 푸시 세팅
  ///
  /// - Parameters:
  ///   - parameter: 파라메터
  ///   - completion: 콜백
  static func upDateMyPush(parameter:[String:String], _ completion: @escaping (String,String) -> Void){
    let url = "\(UserService.url)/push/updateMyPush.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string
            ,let data = json["result"]["data"].string{
            if (json["code"].string ?? "") == "2001"{
              sessionExpireAction()
            }
            completion(result,data)
          }
          
        case .failure(let error):
          completion(error.localizedDescription,"error")
        }
    }
  }
  
  
  /// Qna 등록
  ///
  /// - Parameters:
  ///   - parameter: 파라메터
  ///   - completion: 콜백
  static func insertQna(parameter:[String:String], _ completion: @escaping (String) -> Void){
    let url = "\(UserService.url)/qna/insertQna.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters: parameter)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if (json["code"].string ?? "") == "2001"{
              sessionExpireAction()
            }
            completion(result)
          }
          
        case .failure(let error):
          completion(error.localizedDescription)
        }
    }
  }
  
  
  /// Qna 리스트 가져오기
  ///
  /// - Parameter completion: 콜백
  static func getQnaList(_ completion: @escaping (DataResponse<QnaListData>) -> Void){
    let url = "\(UserService.url)/qna/getQnaList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["code"].string{
            if result == "2001"{
              sessionExpireAction()
            }
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
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if json["code"] == "2001"{
              sessionExpireAction()
            }
            completion(result)
          }
          
        case .failure(let error):
          completion(error.localizedDescription)
        }
    }
  }
  
  static func getIsSecession(_ completion: @escaping (String) -> Void) {
    let url = "\(UserService.url)auth/getIsSecession.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["data"]["is_secession"].string{
            if result == "2001"{
              sessionExpireAction()
            }
            completion(result)
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
          let json = JSON(data: response.data!)
          if let result = json["result"]["code"].string{
            if (json["code"].string ?? "") == "2001"{
              sessionExpireAction()
            }
            completion(result)
          }
          
        case .failure(let error):
          completion(error.localizedDescription)
        }
    }
  }
  
  static func checkSurveyResult(surveyId: String,_ completion: @escaping (NSNumber) -> Void){
    let url = "\(UserService.url)/survey/checkSurveyResult.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url, method: .post, parameters: ["survey_id":surveyId])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        switch response.result{
        case .success(_):
          let json = JSON(data: response.data!)
          if let result = json["result"]["data"]["count"].number{
            completion(result)
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
    }
  }
  
  static func getSurveyById3(surveyId: String) -> Observable<CheeseResultByDate>{
    let provider = MoyaProvider<CheeseCounter>()
    return provider.rx
      .request(.getSurveyById(id: surveyId))
      .asObservable().debug()
      .map(CheeseResultByDate.self)
  }
  
  static func getSurveyById2(surveyId: String) -> Observable<CheeseResultByDate>{
    let provider = MoyaProvider<CheeseCounter>()
    return provider.rx
      .request(.getSurveyById(id: surveyId))
      .asObservable()
      .map(CheeseResultByDate.self)
  }
  
  static func getSurveyById(surveyId: String,_ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    
    let url = "\(UserService.url)/survey/getSurveyById.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    
    manager.request(url,method: .post, parameters:["id":surveyId])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
            return .failure(error)
          }
        }
        completion(response)
    }
  }
  
  static func getSearchSurveyList(search: String, paging: Paging, _ completion: @escaping (DataResponse<CheeseResultByDate>) -> Void){
    
    var pageNumber:Int = 0
    switch paging {
    case .refresh:
      break
    case .next(let pageNum):
      pageNumber = pageNum
    }

    let url = "\(UserService.url)/survey/getSearchSurveyList.json"
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 120
    manager.request(url,method: .post, parameters:["search":search,"page_num":"\(0)"])
      .validate(statusCode: 200..<400)
      .responseJSON { (response) in
        let response: DataResponse<CheeseResultByDate> = response.flatMap{ json in
          if let user = Mapper<CheeseResultByDate>().map(JSONObject: json){
            return .success(user)
          } else {
            let error = MappingError(from: json, to: CheeseResultByDate.self)
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



