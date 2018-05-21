//
//  AlertViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation
import UIKit


class AlertViewCell: UICollectionViewCell{
  static let ID = "AlertViewCell"
  
  var model: NotiModel.Data? {
    didSet{
      self.titleLabel.text = model?.summary
//      self.createLabel.text = model?.created_date.components(separatedBy: " ")[0] ?? ""
      self.contentsLabel.text = model?.contents
      guard let type = model?.type else {return}
      self.typeLabel.text = type.convertAlertType()?.typeString
      self.typeLabel.sizeToFit()
    }
  }
  
  let typeLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 26, y: 14, width: 40, height: 20))
    label.font = UIFont.CheeseFontMedium(size: 12)
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.9990782142, green: 0.8465939164, blue: 0.001548176748, alpha: 1)
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  let calenderImg: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_calendar@1x"))
    return img
  }()
  
  let contentsLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(typeLabel)
    self.addSubview(titleLabel)
    self.addSubview(contentsLabel)
//    self.addSubview(calenderImg)
    
    self.backgroundColor = .white
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(typeLabel.snp.right).offset(10)
      make.centerY.equalTo(typeLabel)
      make.right.equalToSuperview().inset(10)
    }
    
//    calenderImg.snp.makeConstraints { (make) in
//      make.top.equalTo(typeLabel.snp.bottom).offset(10)
//      make.left.equalTo(self.typeLabel)
//    }
    
    contentsLabel.snp.makeConstraints { (make) in
      make.top.equalTo(typeLabel.snp.bottom).offset(10)
      make.left.equalTo(typeLabel)
      make.right.equalToSuperview().inset(10)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
   
}

