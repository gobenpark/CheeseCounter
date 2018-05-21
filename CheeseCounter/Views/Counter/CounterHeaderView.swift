//
//  CounterHeaderView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON


final class CounterHeaderView: UIView {
  
  let disposeBag = DisposeBag()
  
  let icon: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  let configureButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btnSettings"), for: .normal)
    return button
  }()
  
  let topLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    return label
  }()
  
  let recommendCodeLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let copyButton: UIButton = {
    let button = UIButton()
    let attribute = NSAttributedString(string: "복사",
                                       attributes: [NSAttributedStringKey.foregroundColor : UIColor.black,
                                                    NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 12)])
                                                    
    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    button.setAttributedTitle(attribute, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0.5, left: 10, bottom: 0.5, right: 10)
    button.layer.cornerRadius = 10
    button.layer.borderWidth = 1
    button.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(icon)
    addSubview(topLabel)
    addSubview(recommendCodeLabel)
    addSubview(configureButton)
    addSubview(copyButton)
    
    configureButton.isUserInteractionEnabled = true
    
    CheeseService.provider.request(.getMyRank)
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .asObservable()
      .flatMap { (json)  in
        return CheeseService.provider.request(.getMyInfo)
          .mapJSON()
          .map{JSON($0)}
          .map{tempjson in return (json,tempjson)}
          .asObservable()
      }.map{($0.0["result"]["data"],$0.1["result"]["data"])}
      .subscribe(onNext: { [weak self](data) in
        let rank = data.0
        let info = data.1
        let gender = info["gender"].stringValue == "male" ? "남자" : "여자"
        
        let attribute = NSMutableAttributedString(
          string: "\(rank["nickname"].stringValue) (\(rank["title"].stringValue), \(rank["rank"].stringValue)위)\n",
          attributes: [.font : UIFont.CheeseFontMedium(size: 12)])
        attribute.append(
          NSAttributedString(string: "\(gender)/\(info["age"].stringValue)세/\(info["addr2"].stringValue)\n",
            attributes: [.font:UIFont.CheeseFontMedium(size: 12),.foregroundColor:#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
        attribute.append(
          NSAttributedString(string: "보유치즈: \(rank["cheese"].intValue.stringFormattedWithSeparator())치즈",
            attributes: [.font: UIFont.CheeseFontMedium(size: 12),.foregroundColor:#colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)]))
        
        self?.topLabel.attributedText = attribute
        self?.recommendCodeLabel.attributedText = NSAttributedString(string: "내 추천코드: \(UserData.instance.userID.components(separatedBy: "_")[1])",
          attributes: [.font: UIFont.CheeseFontMedium(size: 12),.foregroundColor:#colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)])
        
        let url = info["img_url"].stringValue.hasPrefix("http") ? info["img_url"].stringValue : UserService.imgString + info["img_url"].stringValue
        self?.icon.kf.setImage(with: URL(string: url))

    }).disposed(by: disposeBag)
    addConstraint()
  }
  
  func mapper(model: UserInfoModel){
    let data = model.result.data
    let url = data.img_url.hasPrefix("http") ? data.img_url : UserService.imgString + data.img_url
    icon.kf.setImage(with: URL(string: url))
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
      make.bottom.equalTo(recommendCodeLabel.snp.top)
      make.right.equalTo(configureButton.snp.left)
    }
    
    recommendCodeLabel.snp.makeConstraints{ (make) in
      make.left.equalTo(icon.snp.right).offset(13.5)
      make.top.equalTo(topLabel.snp.bottom)
    }
    
    copyButton.snp.makeConstraints{ (make) in
      make.left.equalTo(recommendCodeLabel.snp.right).offset(5)
      make.bottom.equalTo(recommendCodeLabel)
    }
    
    defer {
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    icon.layer.cornerRadius = icon.frame.width/2
    icon.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
