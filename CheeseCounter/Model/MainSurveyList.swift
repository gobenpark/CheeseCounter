//
//  MainSurveyList.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

struct MainSurveyList: Codable{
  let result: Result
  
  
  struct Result: Codable{
    let code: String
    let data: [CheeseData]
  }
  
  struct CheeseData: Codable{
    
    struct Survey_Result: Codable{
      let ask1_count: String?
      let ask2_count: String?
      let ask3_count: String?
      let ask4_count: String?
      init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ask1_count = try? values.decode(String.self, forKey: .ask1_count)
        ask2_count = try? values.decode(String.self, forKey: .ask2_count)
        ask3_count = try? values.decode(String.self, forKey: .ask3_count)
        ask4_count = try? values.decode(String.self, forKey: .ask4_count)
      }
    }
    
    let id: String
    let type: String
    let created_date: String
    let user_id: String
    let title: String
    let main_img_url: String?
    let limit_date: String
    let ask1: String
    let ask2: String
    let ask3: String?
    let ask4: String?
    let ask1_img_url: String
    let ask2_img_url: String
    let ask3_img_url: String?
    let ask4_img_url: String?
    let hash_tag: String
    let total_count: String
    let user_img_url: String
    let nickname: String
    let is_option: String
    let option_cut_cheese: String
    let option_remain_count: String?
    let option_set_count: String?
    let empathy_count: String
    let is_empathy: String
    let is_enable: String?
    let reply_count: String?
    let result_count: String?
    let select_ask: String?
    let survey_result: Survey_Result?
    /// ## 공감리스트 용도
    let recent_reply: String?
    let like_count: String?
    /// ## 매인 더보기버튼용
    var isExpand = false
    
   
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      type = try values.decode(String.self, forKey: .type)
      created_date = try values.decode(String.self, forKey: .created_date)
      user_id = try values.decode(String.self, forKey: .user_id)
      title = try values.decode(String.self, forKey: .title)
      main_img_url = try? values.decode(String.self, forKey: .main_img_url)
      limit_date = try values.decode(String.self, forKey: .limit_date)
      ask1 = try values.decode(String.self, forKey: .ask1)
      ask2 = try values.decode(String.self, forKey: .ask2)
      ask3 = try? values.decode(String.self, forKey: .ask3)
      ask4 = try? values.decode(String.self, forKey: .ask4)
      ask1_img_url = try values.decode(String.self, forKey: .ask1_img_url)
      ask2_img_url = try values.decode(String.self, forKey: .ask2_img_url)
      ask3_img_url = try? values.decode(String.self, forKey: .ask3_img_url)
      ask4_img_url = try? values.decode(String.self, forKey: .ask4_img_url)
      hash_tag = try values.decode(String.self, forKey: .hash_tag)
      total_count = try values.decode(String.self, forKey: .total_count)
      user_img_url = try values.decode(String.self, forKey: .user_img_url)
      nickname = try values.decode(String.self, forKey: .nickname)
      is_option = try values.decode(String.self, forKey: .is_option)
      option_cut_cheese = try values.decode(String.self, forKey: .option_cut_cheese)
      option_set_count = try values.decodeIfPresent(String.self, forKey: .option_set_count)
      empathy_count = try values.decode(String.self, forKey: .empathy_count)
      is_empathy = try values.decode(String.self, forKey: .is_empathy)
      option_remain_count = try? values.decode(String.self, forKey: .option_remain_count)
      survey_result = try? values.decode(Survey_Result.self, forKey: .survey_result)
      reply_count = try? values.decode(String.self, forKey: .reply_count)
      select_ask = try? values.decode(String.self, forKey: .select_ask)
      result_count = try? values.decode(String.self, forKey: .result_count)
      is_enable = try? values.decode(String.self, forKey: .is_enable)
      recent_reply = try? values.decode(String.self, forKey: .recent_reply)
      like_count = try? values.decode(String.self, forKey: .like_count)
    }
  }
}
