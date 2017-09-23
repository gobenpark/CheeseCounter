//
//  RereplyViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//  cell.tag 는 댓글 아이디임

import UIKit

import SnapKit

class RereplyViewCell: UICollectionViewCell{
  
  var profileimgLeft: Constraint?
  
  fileprivate(set) lazy var profileimg: UIImageView = {
    let img = UIImageView(image: UIImage(named: "profile_small"))
    img.contentMode = .scaleAspectFill
    return img
  }()
  
  fileprivate let replyLabel: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byTruncatingTail
    label.numberOfLines = 0
    label.font = UIFont.CheeseFontRegular(size: 12)
    label.textColor = .lightGray
    return label
  }()
  
  fileprivate let createDateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontLight(size: 12)
    label.textColor = .lightGray
    return label
  }()
  
  fileprivate(set) lazy var sympathyButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "result_like_big_nomal@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "result_like_big_select@1x"), for: .selected)
    return button
  }()
  
  fileprivate(set) lazy var writeReplyButton: UIButton = {
    let button = UIButton()
    button.setAttributedTitle(NSAttributedString(string: "댓글 달기"
      ,attributes: [NSFontAttributeName:UIFont.CheeseFontLight(size: 12),NSForegroundColorAttributeName:UIColor.lightGray])
      ,for: .normal)
    return button
  }()
  
  fileprivate let nickNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    return label
  }()
  
  fileprivate let hartIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "result_like_small@1x"))
    return img
  }()
  
  fileprivate let hartCount: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontLight(size: 12)
    label.textColor = .lightGray
    return label
  }()
  
  var parentID: String = "0"
  var userID: String = ""
  var id: String = ""
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(profileimg)
    self.contentView.addSubview(replyLabel)
    self.contentView.addSubview(createDateLabel)
    self.contentView.addSubview(sympathyButton)
    self.contentView.addSubview(writeReplyButton)
    self.contentView.addSubview(nickNameLabel)
    self.contentView.addSubview(hartIcon)
    self.contentView.addSubview(hartCount)
    
    profileimg.snp.remakeConstraints{ (make) in
      make.top.equalTo(self.snp.topMargin)
      profileimgLeft = make.left.equalToSuperview().inset(10).constraint
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
    
    nickNameLabel.snp.makeConstraints { (make) in
      make.left.equalTo(profileimg.snp.right).offset(10)
      make.top.equalTo(profileimg)
      make.height.equalTo(15)
      make.right.equalTo(sympathyButton.snp.left)
    }
    
    replyLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(nickNameLabel)
      make.right.equalTo(sympathyButton.snp.left).inset(-10)
      make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
    }
    
    hartIcon.snp.makeConstraints { (make) in
      make.left.equalTo(nickNameLabel)
      make.bottom.equalToSuperview().inset(10)
      make.height.equalTo(15)
      make.width.equalTo(15)
    }
    
    hartCount.snp.makeConstraints { (make) in
      make.left.equalTo(hartIcon.snp.right).offset(3)
      make.top.equalTo(hartIcon)
      make.height.equalTo(hartIcon)
      make.width.equalTo(10)
    }
    
    createDateLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(hartIcon)
      make.left.equalTo(hartCount.snp.right).offset(10)
      make.bottom.equalTo(hartIcon)
    }
    
    sympathyButton.snp.remakeConstraints { (make) in
      make.right.equalTo(self.snp.rightMargin).inset(10)
      make.height.equalTo(21)
      make.width.equalTo(21)
      make.centerY.equalToSuperview()
    }
    
    writeReplyButton.snp.remakeConstraints { (make) in
      make.top.equalTo(hartIcon)
      make.left.equalTo(createDateLabel.snp.right).offset(10)
      make.bottom.equalTo(hartIcon)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    profileimg.layer.cornerRadius = profileimg.frame.height/2
    profileimg.layer.masksToBounds = true
  }
  
  func fetchData(data: ReplyList.Data?){
    guard let replyList = data else {return}
    self.userID = replyList.user_id
    self.id = replyList.id
    
    if let parentId = replyList.parent_id {
      if parentId != "0"{
        profileimgLeft?.update(inset: 30)
        self.writeReplyButton.isHidden = true
        self.sympathyButton.isHidden = true
      } else {
        profileimgLeft?.update(inset: 10)
        self.writeReplyButton.isHidden = false
        self.sympathyButton.isHidden = false
      }
      
      self.parentID = parentId
    }
    
    self.tag = Int(replyList.id) ?? 0
    self.replyLabel.text = replyList.contents
    
    if let imgurl = replyList.img_url {
      let url = URL(string: imgurl)
      self.profileimg.kf.setImage(with: url)
    }
    if let isLike = replyList.is_like{
      self.sympathyButton.isSelected = isLike == "1" ?
        true : false
    }
    
    self.nickNameLabel.text = data?.nickname
    self.hartCount.text = data?.like_count ?? "0"
    
    dateSet(of: createDateLabel, data: replyList)
    setNeedsUpdateConstraints()
  }
  
 fileprivate func dateSet(of label: UILabel, data: ReplyList.Data){
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if let start = dateFormatter.date(from: (data.created_date).components(separatedBy: ".")[0]) {
      let cal = Calendar.current
      
      let component = cal.dateComponents([.minute], from: start, to: now).minute ?? 0
      
      if component < 1{
        label.text = "방금전"
      } else if component < 60 {
        label.text = "\(component)분전"
      } else if component < 1440 {
        label.text = "\((component/60))시간전"
      } else {
        label.text = data.created_date.components(separatedBy: " ")[0]
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
