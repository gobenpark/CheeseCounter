//
//  AlertViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
import UIKit

enum AlertType{
  case notice
  case update
  case event
  case reply
  case survey_done
  case cheese_return
  case qna
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
      case .cheese_return:
        return " 골드환급 "
      case .qna:
        return " 답변 "
      case .answer_survey_done:
        return " 응답질문만료 "
      case .reply_empathy:
        return " 댓글공감 "
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
    case "cheese_return":
      return .cheese_return
    case "qna":
      return .qna
    case "answer_survey_done":
      return .answer_survey_done
    case "reply_empathy":
      return .reply_empathy
    default:
      return nil
    }
  }
}

class AlertViewCell: UICollectionViewCell{
  static let ID = "AlertViewCell"
  
  
  var model: PushListData.Data? {
    didSet{
      self.titleLabel.text = model?.summary
      self.createLabel.text = model?.created_date?.components(separatedBy: " ")[0] ?? ""
      
      guard let type = model?.type else {return}
      self.typeLabel.text = type.convertAlertType()?.typeString
      self.typeLabel.sizeToFit()
    }
  }
  
  let typeLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 26, y: 14, width: 40, height: 20))
    label.font = UIFont.CheeseFontMedium(size: 12)
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.9990782142, green: 0.8465939164, blue: 0.001548176748, alpha: 1)
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  let calenderImg: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_calendar@1x"))
    return img
  }()
  
  let createLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(typeLabel)
    self.addSubview(titleLabel)
    self.addSubview(createLabel)
    self.addSubview(calenderImg)
    
    self.backgroundColor = .white
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(typeLabel.snp.right).offset(10)
      make.centerY.equalTo(typeLabel)
      make.right.equalToSuperview().inset(10)
    }
    
    calenderImg.snp.makeConstraints { (make) in
      make.top.equalTo(typeLabel.snp.bottom).offset(10)
      make.left.equalTo(self.typeLabel)
    }
    
    createLabel.snp.makeConstraints { (make) in
      make.left.equalTo(calenderImg.snp.right).offset(10)
      make.centerY.equalTo(calenderImg)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
   
}
