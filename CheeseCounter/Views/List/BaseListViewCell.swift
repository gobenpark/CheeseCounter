//
//  BaseListViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 21..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation


class BaseListViewCell: UICollectionViewCell{
  
  var model: MainSurveyList.CheeseData?
  
  let heartButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icHeartD"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "icHeart"),for: .selected)
    return button
  }()
  
  let peopleImage = UIImageView(image: #imageLiteral(resourceName: "user"))
  let cheeseImage = UIImageView(image: #imageLiteral(resourceName: "icCheese"))
  
  let peopleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13.8)
    return label
  }()
  
  let heartLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13.8)
    label.textColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)
    return label
  }()
  
  let cheeseLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13.8)
    label.textColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)
    return label
  }()
  
  let contents: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 15.7)
    return label
  }()
  
  let detailContents = UILabel()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.addSubview(heartButton)
    contentView.addSubview(cheeseImage)
    contentView.addSubview(heartLabel)
    contentView.addSubview(cheeseLabel)
    contentView.addSubview(contents)
    contentView.addSubview(detailContents)
    contentView.addSubview(peopleImage)
    contentView.addSubview(peopleLabel)
    addConstraint()
  }
  
  public func addConstraint(){
    heartButton.snp.makeConstraints { (make) in
      make.left.equalTo(12.5)
      make.top.equalTo(22.5)
      make.height.equalTo(13.5)
      make.width.equalTo(14.5)
    }
    
    heartLabel.snp.makeConstraints { (make) in
      make.left.equalTo(heartButton.snp.right).offset(6.5)
      make.centerY.equalTo(heartButton)
      make.width.equalTo(21.5)
    }
    
    cheeseImage.snp.makeConstraints { (make) in
      make.left.equalTo(heartLabel.snp.right).offset(32)
      make.centerY.equalTo(heartLabel)
      make.height.equalTo(13.5)
      make.width.equalTo(30)
    }
    
    cheeseLabel.snp.makeConstraints { (make) in
      make.left.equalTo(cheeseImage.snp.right).offset(6.5)
      make.centerY.equalTo(cheeseImage)
      make.width.equalTo(10)
    }
    
    contents.snp.makeConstraints { (make) in
      make.left.equalTo(heartButton)
      make.top.equalTo(heartButton.snp.bottom).offset(16)
      make.right.equalToSuperview().inset(107)
    }
    
    peopleImage.snp.makeConstraints { (make) in
      make.left.equalTo(contents)
      make.top.equalTo(contents.snp.bottom).offset(10)
      make.height.equalTo(cheeseImage)
      make.width.equalTo(cheeseImage)
    }
    
    peopleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(peopleImage.snp.right).offset(6.5)
      make.width.equalTo(10)
      make.centerY.equalTo(peopleImage)
    }
    
    detailContents.snp.makeConstraints { (make) in
      make.left.equalTo(peopleLabel.snp.right).offset(6.5)
      make.centerY.equalTo(peopleLabel)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
