//
//  HistoryViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation

class HistoryViewCell: UICollectionViewCell{
  var item: HistoryModel.Result.Data?{
    didSet{
      self.dateLabel.text = item?.created_date.components(separatedBy: " ")[0]
        .replacingOccurrences(of: "-", with: ".")
      
      
      guard let text = item?.summary else {return}
      self.titleLabel.text = text
      self.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      
//      if text.contains("[질문등록]"){
//        self.titleLabel.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
//      }else if text.contains("[골드구매]"){
//        self.titleLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//      }else if text.contains("[응답참여]"){
//        self.titleLabel.textColor = #colorLiteral(red: 1, green: 0.5535024405, blue: 0.3549469709, alpha: 1)
//      }else if text.contains("[회원가입]"){
//        self.titleLabel.textColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
//      }
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 16)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 11)
    label.textColor = .lightGray
    return label
  }()
  
  let dateImg: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_calendar@1x"))
    return img
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    addSubview(dateLabel)
    addSubview(dateImg)
    self.backgroundColor = .white
    addConstraint()
  }
  
  private func addConstraint(){
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(self.snp.topMargin).inset(3)
    }
    
    dateImg.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.equalTo(titleLabel)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(dateImg.snp.right).offset(10)
      make.centerY.equalTo(dateImg).inset(-1)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
