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
  case getMyPointHistory(type: String, year: String, month: String)
  
  case getMyPush
  case updateMyPush(parameter: [String:String])
  case getMyNotification(pageNum: String)
  
  case getReplyList(surveyId: String)
  case insertReply(survey_id: String, parent_id: String, contents: String)
  case deleteReply(id: String)
  case insertLike(reply_id: String, survey_id: String)
  
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
  case getDetailResult(survey_id: String, selectAsk: String, address: String)
  
  case getQnaList
  case insertQna(title: String, contents: String)
  
  case getEmpathyList(pageNum: String)
  case insertEmpathy(id: String)
  
  case insertSurvey(data: [MultipartFormData])
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
  case getSearchSurveyList(search: String, page_num: Int)
  case getMySearchSurveyList(search: String, page_num: Int)
  case getGiftList
  case buyDirectGift(id: String)
  case regRoulette(gift_id: String,level: String)
  case getRouletteBoard(id: String)
  case updateRouletteRun(id: String, stage: String, re: String)
  case updateRouletteDone(id: String)
  case getSurveyListV2(id: String)
  case getSurveyListV2Search(id: String, search: String)
  case getWinList
  case getMyCouponList
  case getMyCouponById(id: String)
  case getEventSurveyList
  case getSurveyByIdV2(id: String)
  case getEventAllList
  case getTodayEventList
}

extension CheeseCounter: TargetType{
//  public var baseURL: URL {return URL(string: "https://cheesecounter.co.kr/")!}
  public var baseURL: URL {return URL(string: "http://192.168.1.103:8088")!}
  
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
    case .getSearchSurveyList:
      return "/survey/getSearchSurveyList.json"
    case .getMySearchSurveyList:
      return "/survey/getMySearchSurveyList.json"
    case .getGiftList:
      return "/gift/getGiftList.json"
    case .buyDirectGift:
      return "/gift/buyDirectGift.json"
    case .regRoulette:
      return "/game/regRoulette.json"
    case .getRouletteBoard:
      return "/game/getRouletteBoard.json"
    case .updateRouletteRun:
      return "/game/updateRouletteRun.json"
    case .updateRouletteDone:
      return "/game/updateRouletteDone.json"
    case .getSurveyListV2,.getSurveyListV2Search:
      return "/survey/getSurveyListV2.json"
    case .getWinList:
      return "/game/getWinList.json"
    case .getMyCouponList:
      return "/coupon/getMyCouponList.json"
    case .getMyCouponById:
      return "/coupon/getMyCouponById.json"
    case .getEventSurveyList:
      return "/survey/getEventSurveyListV2.json"
    case .getSurveyByIdV2:
      return "/survey/getSurveyByIdV2.json"
    case .getEventAllList:
      return "/event/getEventAllList.json"
    case .getTodayEventList:
      return "/event/getTodayEventList.json"
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
    case .getMyPointHistory(let type, let year, let month):
      return .requestParameters(parameters: ["type": type, "year": year, "month": month], encoding: URLEncoding.queryString)
    case .getReplyList(let surveyId):
      return .requestParameters(parameters: ["survey_id":surveyId], encoding: URLEncoding.queryString)
    case .getDetailResult(let surveyId, let selectAsk, let address):
      return .requestParameters(parameters: ["survey_id": surveyId,"select_ask": selectAsk, "addr":address], encoding: URLEncoding.queryString)
    case .getSearchSurveyList(let search, let pageNum),.getMySearchSurveyList(let search, let pageNum):
      return .requestParameters(parameters: ["search": search,"page_num":pageNum], encoding: URLEncoding.queryString)
    case .regRoulette(let gift_id, let level):
      return .requestParameters(parameters: ["gift_id": gift_id,"level":level], encoding: URLEncoding.queryString)
    case .updateRouletteRun(let id, let s, let re):
      return .requestParameters(parameters: ["id":id,"s":s,"re":re], encoding: URLEncoding.queryString)
    case .updateRouletteDone(let id),
         .buyDirectGift(let id),
         .getSurveyById(let id),
         .getRouletteBoard(let id),
         .getSurveyListV2(let id),
         .getMyCouponById(let id),
         .getSurveyByIdV2(let id),
         .insertEmpathy(let id):
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
    case .insertSurveyResult(let survey_id, let select_ask):
      return .requestParameters(parameters: ["survey_id": survey_id,"select_ask": select_ask], encoding: URLEncoding.queryString)
    case .insertReply(let survey_id, let parent_id, let contents):
      return .requestParameters(parameters: ["survey_id": survey_id,"parent_id":parent_id,"contents":contents], encoding: URLEncoding.queryString)
    case .getMyRegSurveyList(let page_num),.getMyAnswerSurveyList(let page_num),.getMyNotification(let page_num),.getEmpathyList(let page_num):
      return .requestParameters(parameters:["page_num": page_num], encoding: URLEncoding.queryString)
    case .getSurveyListV2Search(let id, let search):
      return .requestParameters(parameters: ["id": id,"search": search], encoding: URLEncoding.queryString)
    case .insertQna(let title, let contents):
      return .requestParameters(parameters: ["title":title,"contents":contents], encoding: URLEncoding.queryString)
    case .insertLike(let id, let survey_id):
      return .requestParameters(parameters: ["reply_id": id,"survey_id": survey_id], encoding: URLEncoding.queryString)
    case .getSurveyResult(let id):
      return .requestParameters(parameters: ["survey_id": id], encoding: URLEncoding.queryString)
    case .insertSurvey(let data):
      return .uploadMultipart(data)
    case .regUser(let parameters):
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    default:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-Type":"application/json"]
  }
}
