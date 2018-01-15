//
//  DetailResultViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 8..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import Eureka

class ListDetailResultViewCell: UICollectionViewCell
{
  
  let genderLabel: CustomLabel = {
    let label = CustomLabel()
    label.textColor = .black
    label.text = "성별"
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.sizeToFit()
    return label
  }()
  
  let maleImg: UIImageView = {
    let img = UIImageView()
    img.image = #imageLiteral(resourceName: "male_nomal@1x")
    return img
  }()
  
  let femaleImg: UIImageView = {
    let img = UIImageView()
    img.image = #imageLiteral(resourceName: "female_nomal@1x")
    return img
  }()
  
  let maleLabel: UILabel = {
    let label = UILabel()
    label.text = "남"
    label.sizeToFit()
    label.textColor = .black
    return label
  }()
  
  let femaleLabel: UILabel = {
    let label = UILabel()
    label.text = "여"
    label.textColor = .black
    label.sizeToFit()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    addSubview(genderLabel)
    addSubview(maleImg)
    addSubview(femaleImg)
    addSubview(maleLabel)
    addSubview(femaleLabel)
    addConstraint()
  }
  
  
  func updateData(data: DetailResult.Data){
    var male = 0
    var female = 0
    
    
    data.gender_age.forEach {
      if $0.category == "male"{
        male += Int($0.count) ?? 0
      }else if $0.category == "female" {
        female += Int($0.count) ?? 0
      }
    }
    
    let attribute = NSMutableAttributedString(string: "남자")
    attribute.append(NSAttributedString(string: "\(male)", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)]))
    attribute.append(NSAttributedString(string: "명"))
    
    let attribute2 = NSMutableAttributedString(string: "여자")
    attribute2.append(NSAttributedString(string: "\(female)", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)]))
    attribute2.append(NSAttributedString(string: "명"))
    
    self.maleLabel.attributedText = attribute
    self.femaleLabel.attributedText = attribute2
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  func addConstraint(){
    
    genderLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top).inset(15)
      make.left.equalTo(self.snp.leftMargin)
    }
    
    maleImg.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(26)
      make.top.equalToSuperview().inset(74)
      make.height.equalTo(146)
      make.width.equalTo(146)
    }
    
    maleLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(maleImg)
      make.top.equalTo(maleImg.snp.bottom).offset(20)
    }
    
    femaleImg.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(26)
      make.top.equalTo(maleImg)
      make.height.equalTo(146)
      make.width.equalTo(146)
    }
    
    femaleLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(femaleImg)
      make.top.equalTo(femaleImg.snp.bottom).offset(20)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  class CustomLabel: UILabel {
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.sizeToFit()
      self.textAlignment = .center
      self.textColor = .black
      self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}


