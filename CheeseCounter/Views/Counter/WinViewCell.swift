//
//  adView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit


class WinViewCell: UICollectionViewCell{
  
  var model: WinListModel.Result.Data?{
    didSet{
      guard let model = model else { return }
      image.kf.setImage(with: URL(string: model.img_url.getUrlWithEncoding()))
      nickname.text = model.nickname + "님 당첨을 축하드립니다!"
      date.text = model.update_date
      
      self.dateSet(of: date, data: model)
    }
  }
  
  let image: UIImageView = {
    let image = UIImageView()
    return image
  }()
  
  let date: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    return label
  }()
  
  let nickname: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(image)
    addSubview(date)
    addSubview(nickname)
    addConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    image.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(22)
      make.width.height.equalTo(30)
    }
    
    date.snp.makeConstraints { (make) in
      make.left.equalTo(image.snp.right).offset(14)
      make.centerY.equalTo(image)
    }
    
    nickname.snp.makeConstraints { (make) in
      make.left.equalTo(date.snp.right).offset(30)
      make.centerY.equalTo(image)
    }
  }
  
  fileprivate func dateSet(of label: UILabel, data: WinListModel.Result.Data){
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if let start = dateFormatter.date(from: (data.update_date).components(separatedBy: ".")[0]) {
      let cal = Calendar.current
      
      let component = cal.dateComponents([.minute], from: start, to: now).minute ?? 0
//      log.info(component)
      
      if component < 1{
        label.text = "방금전"
      } else if component < 60 {
        label.text = "\(component)분전"
      } else if component < 1440 {
        label.text = "\((component/60))시간전"
      } else if component < 40320 {
        label.text = "\(component/1440)일전"
      } else {
        label.text = data.update_date.components(separatedBy: " ")[0]
      }
      
    }
  }
}
