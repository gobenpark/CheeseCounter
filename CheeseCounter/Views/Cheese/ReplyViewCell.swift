//
//  RereplyViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 3..
//  Copyright © 2017년 xiilab. All rights reserved.
//  cell.tag 는 댓글 아이디임

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Moya

class ReplyViewCell: UICollectionViewCell{
  let disposeBag = DisposeBag()
  
  var constraint: Constraint?
  var model: ReplyModel.Data?{
    didSet{
      guard let model = model else {return}
      self.nickNameLabel.text = model.nickname
      self.profileimg.kf.setImage(with: URL(string:model.img_url))
      self.replyLabel.text = model.contents
      self.hartCount.text = model.like_count
      
      self.dateSet(of: self.createDateLabel, data: model)
      
      if model.parent_id != "0"{
        constraint?.update(inset: 30)
        writeReplyButton.isHidden = true
        sympathyButton.isHidden = true
      }
      
      if model.is_like == "1"{
        sympathyButton.isSelected = true
      }
      
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  weak var parentViewController: ReplyViewController?
  
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
    button.setImage(#imageLiteral(resourceName: "icHeart"), for: .selected)
    return button
  }()
  
  fileprivate(set) lazy var writeReplyButton: UIButton = {
    let button = UIButton()
    button.setAttributedTitle(NSAttributedString(string: "댓글 달기"
      ,attributes: [NSAttributedStringKey.font:UIFont.CheeseFontLight(size: 12),NSAttributedStringKey.foregroundColor:UIColor.lightGray])
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
    
    writeReplyButton.rx
      .tap
      .subscribe(onNext:{[weak self] in
        guard let `self` = self ,
          let nickname = self.model?.nickname,
          let parentID = self.model?.id else {return}
        let data = ReplyActionData(nickname: nickname, parentID: parentID)
        self.parentViewController?.writeReplySubject.onNext(data)
    }).disposed(by: disposeBag)
    
    sympathyButton
      .rx
      .tap
      .filter{ [sympathyButton] in
        return !sympathyButton.isSelected
      }.flatMap {[unowned self] _ in
        return CheeseService
          .provider
          .request(.insertLike(reply_id: self.model?.id ?? String(), survey_id: self.model?.survey_id ?? String()))
          .filter(statusCode: 200)
          .asObservable()
    }.do(onNext: {[sympathyButton] _ in
      sympathyButton.isSelected = true
    }).catchErrorJustReturn(Response(statusCode: 400, data: Data()))
      .subscribe(onNext: { (response) in
        if response.statusCode == 200{
          log.info("성공")
        }
      }).disposed(by: disposeBag)
    
    addConstraint()
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    guard let model = model else {return}
    if model.parent_id != "0"{
      writeReplyButton.removeFromSuperview()
    }
  }
  
  private func addConstraint(){
    profileimg.snp.remakeConstraints{ (make) in
      make.top.equalTo(self.snp.topMargin)
      constraint = make.left.equalTo(self.snp.leftMargin).constraint
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
  
 fileprivate func dateSet(of label: UILabel, data: ReplyModel.Data){
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
