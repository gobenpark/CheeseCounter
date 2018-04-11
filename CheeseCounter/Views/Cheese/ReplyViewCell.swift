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
import RxGesture


class ReplyViewCell: UICollectionViewCell, UIGestureRecognizerDelegate{
  let disposeBag = DisposeBag()
  
  var pan: UIPanGestureRecognizer!
  var isSwipeMenuOpened: Bool = false
  
  var deleteLabel: UILabel!
  
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
      }else{
        constraint?.update(inset: 0)
        sympathyButton.isHidden = false
        writeReplyButton.isHidden = false
      }
      
      if model.is_like == "1"{
        sympathyButton.isSelected = true
      }else{
        sympathyButton.isSelected = false
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
    
    self.contentView.backgroundColor = .white
    self.backgroundColor = .red
    
    deleteLabel = UILabel()
    deleteLabel.text = "삭제"
    deleteLabel.textColor = .white
    
    self.insertSubview(deleteLabel, belowSubview: self.contentView)
    
    pan = UIPanGestureRecognizer(target: self, action: #selector(self.onPan))
    pan.delegate = self
    
    self.addGestureRecognizer(pan)
    
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
      .subscribe(onNext: {[weak self] (response) in
        if response.statusCode == 200{
          self?.parentViewController?.replyEmpathyAction.onNext(true)
        }
      }).disposed(by: disposeBag)
    
    deleteLabel.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self, let model = self.model else { return }
        let collectionView: UICollectionView = self.superview as! UICollectionView
        let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
        self.parentViewController?.deleteReplyAction.onNext((model, indexPath)) })
      .disposed(by: disposeBag)
    
    addConstraint()
  }
  
  private func addConstraint(){
    profileimg.snp.remakeConstraints{ (make) in
      make.top.equalTo(self.contentView.snp.topMargin)
      constraint = make.left.equalTo(self.contentView.snp.leftMargin).constraint
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
    
    if (pan.state == UIGestureRecognizerState.changed) {
      let p: CGPoint = pan.translation(in: self)
      let width = self.contentView.frame.width
      let height = self.contentView.frame.height
      
      var x = p.x
      if x < -100 {
        x = -100
      }
      if x > 0 {
        x = 0
      }
      self.contentView.frame = CGRect(x: x, y: 0, width: width, height: height)
      self.deleteLabel.frame = CGRect(x: x + width + 20, y: 0, width: 100, height: height)
    }
  }
  
  
  @objc func onPan(_ pan: UIPanGestureRecognizer) {
    guard let model = self.model else { return }
    
    if model.user_id != UserData.instance.userID || model.hasReply {
      return
    }
    
    let p: CGPoint = pan.translation(in: self)
    if pan.state == UIGestureRecognizerState.began {
      
    } else if pan.state == UIGestureRecognizerState.changed {
      self.setNeedsLayout()
      //self.layoutIfNeeded()
    } else {
      if abs(pan.velocity(in: self).x) > 500 {
        self.isSwipeMenuOpened = true
        
      } else {
        // touch up OR touch cancel
        if p.x < -80 {
          self.isSwipeMenuOpened = true
        } else {
          self.isSwipeMenuOpened = false
        }
      }
      
      if !self.isSwipeMenuOpened {
        // cancel
        // 메뉴 닫기
        UIView.animate(withDuration: 0.2, animations: {
          
          self.setNeedsLayout()
          self.layoutIfNeeded()
        })
      } else {
        // 메뉴 열기
        UIView.animate(withDuration: 0.2, animations: {
          let width = self.contentView.frame.width
          let height = self.contentView.frame.height
          self.contentView.frame = CGRect(x: -100, y: 0, width: width, height: height)
          self.deleteLabel.frame = CGRect(x: -80 + width, y: 0, width: 100, height: height)
        })
      }
    }
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
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
