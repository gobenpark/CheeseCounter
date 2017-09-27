//
//  MyService.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 16..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Moya

public enum CheeseCounter{
  
  case getMyPoint
  case getMyPointHistory(parameter: [String:String])
  
  case getMyPush
  case updateMyPush(parameter: [String:String])
  case getMyNotification(pageNum: String)
  
  case getReplyList(surveyId: String)
  case insertReply(parameter: [String:String])
  case deleteReply(id: String)
  case insertLike(parameter: [String:String])
  
  case getBaseImgList
  
  case getNoticeList
  
  case loginUser(id: String, fcm_token: String, img_url: String, access_token: String,version: String)
  case regUser(parameter: [String:String])
  case checkNickname(nickname: String)
  case logout
  case getRegion
  case insertSecession
  case deleteSecession
  case getBankList
  case getMyInfo
  
  case getSurveyResult(surveyId: String)
  case getDetailResult(parameter: [String:String])
  
  case getQnaList
  case insertQna(parameter: [String:String])
  
  case getEmpathyList(pageNum: String)
  case insertEmpathy(id: String)
  
  case insertSurvey(parameters: [String:String])
  case checkSurveyResult
  case insertSurveyResult(surveyId: String,select: String)
  case getSurveyList
  case getSurveyListByDate(parameters: [String:String])
  case getSurveyListByOption(pageNum: String)
  case getMyRegSurveyList(pageNum: String)
  case getMyAnswerSurveyList(pageNum: String)
  
  case insertCheeseReturn(parameter: [String:String])
  
  case getMyRank
  case getTopRankList
  
  case fcmSender(fcm_token: String)
  case getSurveyById(id: String)
}

extension CheeseCounter: TargetType{
  public var baseURL: URL {return URL(string: "https://cheesecounter.co.kr/")!}
//  public var baseURL: URL {return URL(string: "http://192.168.1.39:8088")!}
  
  public var path: String {
    switch self{
    case .getMyPoint:
      return "/point/getMyPoint.json"
    case .getMyPointHistory:
      return "/point/getMyPointHistory.json"
    case .getMyPush:
      return "/push/getMyPush.json"
    case .updateMyPush:
      return "/push/updateMyPush.json"
    case .getMyNotification:
      return "/push/getMyNotification.json"
    case .getReplyList:
      return "/reply/getReplyList.json"
    case .insertReply:
      return "/reply/insertReply.json"
    case .deleteReply:
      return "/reply/deleteReply.json"
    case .insertLike:
      return "/reply/insertLike.json"
    case .getBaseImgList:
      return "/baseImg/getBaseImgList.json"
    case .getNoticeList:
      return "/notice/getNoticeList.json"
    case .loginUser:
      return "/auth/loginUser.json"
    case .regUser:
      return "/auth/regUser.json"
    case .checkNickname:
      return "/auth/checkNickname.json"
    case .logout:
      return "/auth/logout.json"
    case .getRegion:
      return "/auth/getRegion.json"
    case .insertSecession:
      return "/auth/insertSecession.json"
    case .deleteSecession:
      return "/auth/deleteSecession.json"
    case .getBankList:
      return "/auth/getBankList.json"
    case .getMyInfo:
      return "/auth/getMyInfo.json"
    case .getSurveyResult:
      return "/survey/getSurveyResult.json"
    case .getDetailResult:
      return "/survey/getDetailResult.json"
    case .getQnaList:
      return "/qna/getQnaList.json"
    case .insertQna:
      return "/qna/insertQna.json"
    case .getEmpathyList:
      return "/empathy/getEmpathyList.json"
    case .insertEmpathy:
      return "/empathy/insertEmpathy.json"
    case .insertSurvey:
      return "/survey/insertSurvey.json"
    case .checkSurveyResult:
      return "/survey/checkSurveyResult.json"
    case .insertSurveyResult:
      return "/survey/insertSurveyResult.json"
    case .getSurveyList:
      return "/survey/getSurveyList.json"
    case .getSurveyListByDate:
      return "/survey/getSurveyListByDate.json"
    case .getSurveyListByOption:
      return "/survey/getSurveyListByOption.json"
    case .getMyRegSurveyList:
      return "/survey/getMyRegSurveyList.json"
    case .getMyAnswerSurveyList:
      return "/survey/getMyAnswerSurveyList.json"
    case .insertCheeseReturn:
      return "/auth/insertCheeseReturn.json"
    case .getMyRank:
      return "/rank/getMyRank.json"
    case .getTopRankList:
      return "/rank/getTopRankList.json"
    case .fcmSender:
      return "/auth/updateFcmToken.json"
    case .getSurveyById:
      return "/survey/getSurveyById.json"
    }
  }
  
  public var method: Moya.Method {
    return .post
  }
  
  public var sampleData: Moya.Data {
    return Data()
  }
  
  public var validate: Bool{
    return true
  }
  
  public var task: Task {
    switch self{
    case .getMyNotification(let pageNum):
      return .requestParameters(parameters: ["page_num":pageNum], encoding: URLEncoding.queryString)
      //      return ["page_num":pageNum]
    case .getReplyList(let surveyId):
      return .requestParameters(parameters: ["survey_id":surveyId], encoding: URLEncoding.queryString)
      //      case .insertReply(let parameter):
      //      return parameter
      //      case .deleteReply(let id):
      //      return ["id":id]
      //      case .insertLike(let parameter):
      //      return parameter
      //      case .loginUser(let id,let fcm,let img,let access,let version):
      //      return ["id":id,"fcm_token":fcm,"img_url":img,"access_token":access,"version":version]
      //      case .checkNickname(let nickname):
      //      return ["nickname":nickname]
      //      case .regUser(let parameter):
      //      return parameter
      //      case .getSurveyListByDate(let parameter):
      //      return parameter
      //      case .insertSurvey(let parameters):
      //      return parameters
      //      case .getSurveyResult(let id):
      //      return ["survey_id":id]
      //      case .insertSurveyResult(let id,let select):
      //      return ["survey_id":id,"select_ask":select]
      //      case .getSurveyListByOption(let pageNum):
      //      return ["page_num":pageNum]
    case .getDetailResult(let parameter):
      return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
      //      case .getMyRegSurveyList(let pageNum):
      //      return ["page_num":pageNum]
      //      case .getMyAnswerSurveyList(let pageNum):
      //      return ["page_num":pageNum]
      //      case .getEmpathyList(let pageNum):
      //      return ["page_num":pageNum]
      //      case .insertEmpathy(let id):
      //      return ["id":id]
      //      case .fcmSender(let token):
    //      return ["fcm_token":token]
    case .getSurveyById(let id):
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
    default:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type":"application/json"]
  }
}
