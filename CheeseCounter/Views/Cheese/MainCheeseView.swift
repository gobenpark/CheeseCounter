//
//  MainView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 6..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import AnyDate

class MainCheeseView: UIView {
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      selectView.model = model
      title.text = model?.title
      cheeseCount.text = model?.option_cut_cheese
      peopleCount.text = model?.total_count
      
      if let type = model?.type{
        if type == "2"{
          selectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(selectView.snp.width).dividedBy(2)
            make.right.equalToSuperview()
            make.bottom.equalTo(dividLine.snp.top).offset(-33.5)
          }
        }else {
          selectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(selectView.snp.width)
            make.right.equalToSuperview()
            make.bottom.equalTo(dividLine.snp.top).offset(-33.5)
          }
        }
      }
      
      if let empathy = model?.empathy_count,let reply = model?.reply_count{
        emptyReplyLabel.text = "공감 \(empathy) 댓글 \(reply)개"
        emptyReplyLabel.sizeToFit()
      }
      self.heartButton.isSelected = (model?.is_empathy == "1") ? true : false
      cheeseCount.sizeToFit()
      peopleIcon.sizeToFit()
      peopleCount.sizeToFit()
    }
  }
  
  let title: TTTAttributedLabel = {
    let label = TTTAttributedLabel(frame: .zero)
    label.font = UIFont.CheeseFontMedium(size: 16.6)
    label.numberOfLines = 0
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  let emptyReplyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 10.2)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let cheeseIcon: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "icCheese"))
    return image
  }()
  
  let cheeseCount: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14.1)
    label.textColor = #colorLiteral(red: 0.9980220199, green: 0.4893858433, blue: 0.3179949522, alpha: 1)
    return label
  }()
  
  let selectView: MainSurveyImageView = {
    let image = MainSurveyImageView()
    return image
  }()
  
  let peopleIcon: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "user"))
    return image
  }()
  
  let peopleCount: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 10.2)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  
  let heartButton: UIButton = {
    let button = UIButton()
    button.setTitle(" 공감하기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1), for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 12.6)
    button.setImage(#imageLiteral(resourceName: "icHeart"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "icHeartP"), for: .selected)
    button.semanticContentAttribute = .forceLeftToRight
    return button
  }()
  
  let commentButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1), for: .normal)
    button.setTitle(" 댓글달기", for: .normal)
    button.setImage(#imageLiteral(resourceName: "icComments"), for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 12.6)
    button.semanticContentAttribute = .forceLeftToRight
    return button
  }()
  
  
  
  let shareButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1), for: .normal)
    button.setTitle(" 공유하기", for: .normal)
    button.setImage(#imageLiteral(resourceName: "icShare"), for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 12.6)
    button.semanticContentAttribute = .forceLeftToRight
    return button
  }()
  
  let shareLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 12.6)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return view
  }()
  
  let moreButton: UIButton = {
    let button = UIButton()
    button.setTitle("더보기", for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 11.8)
    button.setTitleColor(#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1), for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(title)
    addSubview(cheeseIcon)
    addSubview(emptyReplyLabel)
    addSubview(cheeseCount)
    addSubview(selectView)
    addSubview(peopleCount)
    addSubview(peopleIcon)
    addSubview(heartButton)
    addSubview(commentButton)
    addSubview(shareButton)
    addSubview(shareLabel)
    addSubview(dividLine)
    addSubview(moreButton)
    addConstraint()
  }
  
  private func addConstraint(){
    
    title.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12)
      make.top.equalToSuperview().inset(14)
      make.right.equalToSuperview().inset(61)
      make.bottom.equalTo(selectView.snp.top).offset(-14.5)
    }
    
    cheeseIcon.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(24)
      make.top.equalToSuperview().inset(20)
      make.height.equalTo(14)
      make.width.equalTo(cheeseIcon.snp.height)
    }
    
    cheeseCount.snp.makeConstraints { (make) in
      make.left.equalTo(cheeseIcon.snp.right).offset(5.5)
      make.centerY.equalTo(cheeseIcon)
    }
    
    selectView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.height.equalTo(selectView.snp.width).dividedBy(2)
      make.right.equalToSuperview()
      make.bottom.equalTo(dividLine.snp.top).offset(-33.5)
    }
    
    peopleIcon.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12)
      make.top.equalTo(selectView.snp.bottom).offset(11)
    }
    
    peopleCount.snp.makeConstraints { (make) in
      make.left.equalTo(peopleIcon.snp.right).offset(4.5)
      make.centerY.equalTo(peopleIcon)
    }

    dividLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(33.5)
      make.height.equalTo(1)
    }
    
    heartButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12.5)
      make.top.equalTo(dividLine.snp.bottom).offset(9)
    }
    
    commentButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(dividLine.snp.bottom).offset(9)
    }
    
    shareButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(11.5)
      make.top.equalTo(dividLine.snp.bottom).offset(9)
    }
    
    emptyReplyLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(peopleIcon)
      make.right.equalToSuperview().inset(11)
    }
    
    moreButton.snp.makeConstraints { (make) in
      make.top.equalTo(cheeseIcon.snp.bottom).offset(11.5)
      make.right.equalToSuperview().inset(12)
      make.height.equalTo(30)
    }
  }
  private func dateConvert(model: MainSurveyList.CheeseData?) -> String?{
    guard let mainModel = model else {return nil}
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    guard let limitTime = ZonedDateTime.parse(mainModel.limit_date, formatter: dateFormatter),
      let startTime = ZonedDateTime.parse(mainModel.created_date, formatter: dateFormatter) else {return nil}
    
    return "\(startTime.year-2000)/\(startTime.month)/\(startTime.day) ~ \(limitTime.year-2000)/\(limitTime.month)/\(limitTime.day)"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


