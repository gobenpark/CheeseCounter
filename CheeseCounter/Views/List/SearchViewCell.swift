//
//  SearchViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

final class SearchViewCell: UICollectionViewCell{
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      heartLabel.text = model?.like_count
      peopleLabel.text = model?.reply_count
      contents.text = model?.title
    }
  }
  
  let heartButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "result_like_small@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "result_like_big_select@1x"), for: .selected)
    return button
  }()
  
  let heartLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13.8)
    label.textColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)
    return label
  }()
  
  let peopleImage = UIImageView(image: #imageLiteral(resourceName: "user"))
  let contents: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 15.7)
    return label
  }()
  
  let peopleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13.8)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(heartButton)
    contentView.addSubview(heartLabel)
    contentView.addSubview(contents)
    contentView.addSubview(peopleImage)
    contentView.addSubview(peopleLabel)
    backgroundColor = .white
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
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
    
    contents.snp.makeConstraints { (make) in
      make.left.equalTo(heartButton)
      make.top.equalTo(heartButton.snp.bottom).offset(16)
      make.right.equalToSuperview().inset(107)
    }
    
    peopleImage.snp.makeConstraints { (make) in
      make.left.equalTo(contents)
      make.top.equalTo(contents.snp.bottom).offset(10)
      make.height.equalTo(13.5)
      make.width.equalTo(13.5)
    }
    
    peopleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(peopleImage.snp.right).offset(6.5)
      make.width.equalTo(43)
      make.centerY.equalTo(peopleImage)
    }
  }
}
