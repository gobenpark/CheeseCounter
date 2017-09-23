//
//  CounterProfileView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 18..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CounterProfileCell: UITableViewCell {
  
  static let ID = "CounterProfileCell"
  
  let imgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "profile_medium"))
    img.contentMode = .scaleAspectFill
    return img
  }()
  
  let divideLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.99031955, green: 0.8599840999, blue: 0.05472854525, alpha: 1)
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    self.contentView.addSubview(imgView)
    self.contentView.addSubview(divideLine)
    
    imgView.snp.makeConstraints{ (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.6)
      make.width.equalTo(imgView.snp.height)
    }

    divideLine.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.height.equalTo(1)
    }
    layoutIfNeeded()
  }
  
  override func layoutSubviews() {
    
    imgView.layer.cornerRadius = self.frame.size.height * 0.3
    imgView.layer.masksToBounds = true
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
