//
//  MainViewCell.swift
//  er
//
//  Created by xiilab on 2018. 1. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

final class MainViewCell: UICollectionViewCell{
  
  let disposeBag = DisposeBag()
  var clickEvent: PublishSubject<(Int,MainSurveyList.CheeseData)>?{
    didSet{
      subjectBind()
    }
  }
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      selectView.model = model
      title.text = model?.title
      cheeseCount.text = model?.option_cut_cheese
      peopleCount.text = model?.total_count
      calendarLabel.text = model?.limit_date
      heartLabel.text = model?.empathy_count
      
      moreButton.isHidden = title.textCount(amount: 20)
      
      cheeseCount.sizeToFit()
      peopleLabel.sizeToFit()
      peopleCount.sizeToFit()
      calendarLabel.sizeToFit()
    }
  }
  
  let title: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 16.6)
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
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
  
  let selectView: CheeseImageView = {
    let image = CheeseImageView()
    return image
  }()
  
  let peopleLabel: UILabel = {
    let label = UILabel()
    label.text = "응답자 :"
    label.font = UIFont.CheeseFontMedium(size: 10.2)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let peopleCount: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 10.2)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let calendarIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "calendar"))
    return icon
  }()
  
  let calendarLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 10.2)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let heartIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "icHeart"))
    return icon
  }()
  
  let heartLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 12.6)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let commentIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "icComments"))
    return icon
  }()
  
  let commentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 12.6)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let shareIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "icShare"))
    return icon
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
    
    contentView.backgroundColor = .white
    contentView.addSubview(title)
    contentView.addSubview(cheeseIcon)
    contentView.addSubview(cheeseCount)
    contentView.addSubview(selectView)
    contentView.addSubview(peopleCount)
    contentView.addSubview(peopleLabel)
    contentView.addSubview(calendarIcon)
    contentView.addSubview(calendarLabel)
    contentView.addSubview(heartIcon)
    contentView.addSubview(heartLabel)
    contentView.addSubview(commentIcon)
    contentView.addSubview(commentLabel)
    contentView.addSubview(shareIcon)
    contentView.addSubview(shareLabel)
    contentView.addSubview(dividLine)
    contentView.addSubview(moreButton)

    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func subjectBind(){
    
    selectView.imageButton1
      .rx
      .tap
      .subscribe { (event) in
        self.selectView.imageButton1.isSelected = true
    }.disposed(by: disposeBag)
    
    selectView.imageButton1
      .rx
      .tap
      .map { [weak self] in
        return (0,(self?.model)!)}
      .bind(to: clickEvent!)
      .disposed(by: disposeBag)
    
    selectView.imageButton2
      .rx
      .tap
      .map { [weak self] in
        return (1,(self?.model)!)}
      .bind(to: clickEvent!)
      .disposed(by: disposeBag)
    
    selectView.imageButton3
      .rx
      .tap
      .map { [weak self] in
        return (2,(self?.model)!)}
      .bind(to: clickEvent!)
      .disposed(by: disposeBag)
    
    selectView.imageButton4
      .rx
      .tap
      .map { [weak self] in
        return (3,(self?.model)!)}
      .bind(to: clickEvent!)
      .disposed(by: disposeBag)
    
//    title.rx.observe(String.self, "text")
//      .subscribe {[weak self] (event) in
//        self?.moreButton.isHidden = self?.title.isTruncated() ?? false
//        self?.reloadInputViews()
//    }.disposed(by: disposeBag)
  }
  
  private func addConstraint(){
    
    title.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12)
      make.top.equalToSuperview().inset(14)
      make.right.equalToSuperview().inset(61)
      make.height.equalTo(50)
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
      make.top.equalTo(title.snp.bottom).offset(10)
      make.right.equalToSuperview()
      make.bottom.equalTo(dividLine.snp.top).offset(-33.5)
    }
    
    peopleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12)
      make.top.equalTo(selectView.snp.bottom).offset(11)
      peopleLabel.sizeToFit()
    }
    
    peopleCount.snp.makeConstraints { (make) in
      make.left.equalTo(peopleLabel.snp.right).offset(4.5)
      make.top.equalTo(peopleLabel)
    }
    
    calendarIcon.snp.makeConstraints { (make) in
      make.left.equalTo(peopleCount.snp.right).offset(67.5)
      make.top.equalTo(selectView.snp.bottom).offset(11)
      make.height.equalTo(13)
      make.width.equalTo(14)
    }
    
    calendarLabel.snp.makeConstraints { (make) in
      make.left.equalTo(calendarIcon.snp.right).offset(4.5)
      make.top.equalTo(selectView.snp.bottom).offset(11)
    }
    
    dividLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(33.5)
      make.height.equalTo(1)
    }
    
    heartIcon.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12.5)
      make.top.equalTo(dividLine.snp.bottom).offset(10.5)
      make.width.equalTo(13.5)
      make.height.equalTo(12.5)
    }
    
    heartLabel.snp.makeConstraints { (make) in
      make.left.equalTo(heartIcon.snp.right).offset(7.5)
      make.centerY.equalTo(heartIcon)
    }
    
    commentIcon.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview().offset(-10)
      make.top.equalTo(dividLine.snp.bottom).offset(10.5)
      make.width.equalTo(13.5)
      make.height.equalTo(12.5)
    }
    
    commentLabel.snp.makeConstraints { (make) in
      make.left.equalTo(commentIcon.snp.right).offset(9)
      make.centerY.equalTo(commentIcon)
    }
    
    shareIcon.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(34)
      make.top.equalTo(dividLine.snp.bottom).offset(10.5)
      make.height.equalTo(12.5)
      make.width.equalTo(10.5)
    }
    
    shareLabel.snp.makeConstraints { (make) in
      make.left.equalTo(shareIcon.snp.right).offset(8)
      make.centerY.equalTo(shareIcon)
    }

    moreButton.snp.makeConstraints { (make) in
      make.top.equalTo(cheeseIcon.snp.bottom).offset(11.5)
      make.right.equalToSuperview().inset(12)
      make.height.equalTo(11)
    }
  }
}

