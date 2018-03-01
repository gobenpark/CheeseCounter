//
//  adView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

class AdView: UIView{
  
  var model: WinListModel.Data?{
    didSet{
      guard let model = model else {return}
      image.kf.setImage(with: URL(string: model.img_url.getUrlWithEncoding()))
      label.text = model.nickname + "님 당첨을 축하드립니다!"
      dateLabel.text = model.update_date
    }
  }
  
  let image: UIImageView = {
    let image = UIImageView()
    return image
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    return label
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(image)
    addSubview(dateLabel)
    addSubview(label)
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    image.snp.makeConstraints { (make) in
      make.top.left.bottom.equalToSuperview().inset(5)
      make.width.equalTo(image.snp.height)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(image.snp.right).offset(10)
      make.centerY.equalTo(image)
    }
    
    label.snp.makeConstraints { (make) in
      make.centerY.equalTo(image)
      make.left.equalTo(dateLabel.snp.right).offset(10)
    }
  }
}
