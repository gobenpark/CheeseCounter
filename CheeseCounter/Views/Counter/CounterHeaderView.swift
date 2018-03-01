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
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(icon)
    addSubview(topLabel)
    addSubview(configureButton)
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
          string: "\(rank["nickname"].stringValue) (\(rank["title"].stringValue))\n",
          attributes: [.font : UIFont.CheeseFontMedium(size: 12)])
        attribute.append(
          NSAttributedString(string: "\(gender)/\(info["age"].stringValue)세/\(info["addr2"].stringValue)\n",
            attributes: [.font:UIFont.CheeseFontMedium(size: 12),.foregroundColor:#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
        attribute.append(
          NSAttributedString(string: "보유치즈: \(rank["cheese"].intValue.stringFormattedWithSeparator())치즈",
                             attributes: [.font: UIFont.CheeseFontMedium(size: 12),.foregroundColor:#colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)]))
        self?.topLabel.attributedText = attribute
    }).disposed(by: disposeBag)

    addConstraint()
  }
  
  func mapper(model: UserInfoModel){
    let data = model.result.data
    icon.kf.setImage(with: URL(string:data.img_url))
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
