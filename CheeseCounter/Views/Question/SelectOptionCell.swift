//
//  SelectEndDateCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectOptionCell: UITableViewCell{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 15)
    return label
  }()
  
  let subTitleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.lineBreakMode = .byTruncatingTail
    label.numberOfLines = 2
    label.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0.2745098039, alpha: 1)
    label.isUserInteractionEnabled = true 
    return label
  }()
  
  let dividedView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(subTitleLabel)
    contentView.addSubview(dividedView)
    
    self.selectionStyle = .none
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.topMargin)
      make.left.equalToSuperview().inset(25)
      make.height.equalTo(30)
      make.width.equalTo(70)
    }
    
    subTitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.snp.rightMargin)
      make.bottom.equalTo(self.snp.bottomMargin)
    }
    setLabelText()
    
    dividedView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalToSuperview()
      make.height.equalTo(0.5)
    }
  }
  func setLabelText(){}
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
