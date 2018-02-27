//
//  CounterHeaderView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

class CounterHeaderView: UIView {
  
  let icon: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  let configureButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btnSettings"), for: .normal)
    return button
  }()
  
  let topLabel = UILabel()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(icon)
    addSubview(topLabel)
    addSubview(configureButton)
    configureButton.isUserInteractionEnabled = true
    addConstraint()
  }
  
  func mapper(model: UserInfoModel){
    let data = model.result.data
    icon.kf.setImage(with: URL(string:data.img_url))
    
    let attributeString = NSMutableAttributedString(
      string: "\(data.nickname)(\n",
      attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 12)])
    attributeString.append(
      NSAttributedString(string: "\(data.gender)/\(data.age)/\(data.addr)",
        attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 12)]))
    attributeString.append(
      NSAttributedString(string: "보유치즈", 
                         attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 12)]))
    
    topLabel.attributedText = attributeString
    
//    let attributeText = NSMutableAttributedString(string: "\(data.nickname ?? "") (\(value.data?.title ?? ""), \(value.data?.rank ?? "")위)"
    //          , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)])
    //
    //        attributeText.append(NSAttributedString(string: "\nMy치즈 : \(cheese)치즈", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)]))
    //
    //        attributeText.append(NSAttributedString(string: "\n\(self.getKoreanGenderName(gender: data.gender ?? ""))/\(data.age ?? "")세/\(data.addr2 ?? "")"
    //          , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
    //        self.extendView.nickNameLabel.attributedText = attributeText
    //        let urlString = data.img_url ?? ""
    //        let url = URL(string: urlString)
    //        if urlString != "nil" {
    //          self.extendView.profileImg.kf.setImage(with: url)
    //        }
    //
    
  }
  
  private func addConstraint(){
    icon.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(12.5)
      make.top.equalToSuperview().inset(5)
      make.bottom.equalToSuperview().inset(5)
      make.width.equalTo(icon.snp.height)
    }
    
    configureButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(12)
      make.top.equalTo(icon)
      make.bottom.equalTo(icon)
      make.width.equalTo(configureButton.snp.height)
    }
    
    topLabel.snp.makeConstraints { (make) in
      make.left.equalTo(icon.snp.right).offset(13.5)
      make.top.equalTo(icon)
      make.bottom.equalTo(topLabel)
      make.right.equalTo(configureButton.snp.left)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
