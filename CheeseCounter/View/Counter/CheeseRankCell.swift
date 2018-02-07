//
//  CheeseRankCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit


class CheeseRankViewCell: UICollectionViewCell{
  
  var item: (RankViewModel.Item)?{
    didSet{
      guard let item = item else {return}
      rankLabel.text = item.rank
      profileImg.kf.setImage(with: URL(string: item.img_url))
      let attribute = NSMutableAttributedString(string: item.nickname,
                                                attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 14)])
      attribute.append(NSAttributedString(string: "\n\(item.title ?? "")",
        attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11),NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.9960784314, green: 0.4705882353, blue: 0.2862745098, alpha: 1)]))
      idLabel.attributedText = attribute
      if let cheese = Int(item.cheese){
        cheeseLabel.text = cheese.stringFormattedWithSeparator() + " 치즈"
      }
    }
  }
  
  let rankLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14.7)
    return label
  }()
  
  let profileImg: UIImageView = {
    let imgView = UIImageView()
    imgView.layer.masksToBounds = true
    imgView.layer.cornerRadius = 70/4
    return imgView
  }()
  
  let idLabel: UILabel = {
    let label = UILabel()
    
    label.numberOfLines = 2
    return label
  }()
  
  let cheeseLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textAlignment = .right
    label.textColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(rankLabel)
    contentView.addSubview(profileImg)
    contentView.addSubview(idLabel)
    contentView.addSubview(cheeseLabel)
    
    rankLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.centerY.equalToSuperview().inset(-1)
      make.width.equalTo(30)
    }
    
    profileImg.snp.makeConstraints { (make) in
      make.left.equalTo(rankLabel.snp.right).offset(5)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
      make.width.equalTo(profileImg.snp.height)
    }
    
    idLabel.snp.makeConstraints { (make) in
      make.left.equalTo(profileImg.snp.right).offset(10)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().inset(1)
      make.width.equalToSuperview().dividedBy(2.5)
    }
    
    cheeseLabel.snp.makeConstraints { (make) in
      make.left.equalTo(idLabel.snp.right)
      make.bottom.equalTo(idLabel)
      make.top.equalTo(idLabel)
      make.right.equalToSuperview().inset(25)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CheeseRankReuseView: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Top 100"
    label.font = UIFont.CheeseFontRegular(size: 14)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(titleLabel)
    self.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
