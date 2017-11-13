//
//  CarouseCell.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

final class CarouselCell2: CarouselBaseCell
{
  var data: CheeseResultByDate.Data?{
    didSet{
      var urlString1 = data?.ask1_img_url ?? ""
      var urlString2 = data?.ask2_img_url ?? ""
      
      if urlString1 == "" {
        urlString1 = "/img/default1.png"
        data?.ask1_img_url = urlString1
      }
      if urlString2 == ""{
        urlString2 = "/img/default2.png"
        data?.ask2_img_url = urlString2
      }

      imageView[0].kf.setImage(with: URL(string: urlString1.getUrlWithEncoding()),
                               placeholder: nil,
                               options: nil,
                               progressBlock: nil) {[weak self] (image, error, type, url) in
                                
        guard let `self` = self else {return}
        UIGraphicsBeginImageContext(CGSize(width: self.imageView[0].frame.width, height: self.imageView[1].frame.height))
        image?.draw(in: CGRect(x: -70, y: 0, width: self.imageView[0].frame.width, height: self.imageView[0].frame.height))
        self.imageView[0].image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
      }
      
      imageView[1].kf.setImage(with: URL(string: urlString2.getUrlWithEncoding()),
                               placeholder: nil,
                               options: nil,
                               progressBlock: nil) {[weak self] (image, error, type, url) in
                                
        guard let `self` = self else {return}
        UIGraphicsBeginImageContext(CGSize(width: self.imageView[1].frame.width, height: self.imageView[1].frame.height))
        image?.draw(in: CGRect(x: 70, y: 0, width: self.imageView[1].frame.width, height: self.imageView[1].frame.height))
        self.imageView[1].image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
      }
      
    
      self.endDateLabel.text = (data?.limit_date?.components(separatedBy: " ")[0] ?? "")
        .replacingOccurrences(of: "-", with: "/")
      self.titleLabel.text = data?.title
      self.cheeseIconImg.pointLabel.text = data?.option_cut_cheese ?? ""
      
      
      guard let option = data?.is_option else {return}
      if option == "1"{
        self.peopleCount.text = (data?.total_count ?? "")+"/"+(data?.option_set_count ?? "")
        self.cheeseIconImg.badgeType = .gold
      } else {
        self.peopleCount.text = data?.total_count ?? ""
        self.cheeseIconImg.badgeType = .cheese
      }
      setNeedsDisplay()
    }
  }
  
  lazy var imageView:[UIImageView] = {
    var iv = [UIImageView]()
    for _ in 0...1 {
      let imgView = UIImageView(frame: self.bounds)
      iv.append(imgView)
    }
    return iv
  }()
  
  var isMoveImage: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    imageView[0].kf.indicatorType = .activity
    imageView[1].kf.indicatorType = .activity
    
    addSubview(imageView[0])
    addSubview(imageView[1])
    addSubview(cheeseIconImg)
    
    addConstraint()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView[0].addParallelogramMaskToView(isTop: true)
    imageView[1].addParallelogramMaskToView(isTop: false)
  }
  
 fileprivate func moveImageContext(imageView: UIImageView,x: CGFloat){
    
    UIGraphicsBeginImageContext(CGSize(width: imageView.frame.width, height: imageView.frame.height))
    imageView.image?.draw(in: CGRect(x: x, y: 0, width: imageView.frame.width, height: imageView.frame.height))
    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  fileprivate func addConstraint(){
    
    imageView[0].snp.remakeConstraints { (make) in
      make.top.equalTo(self.snp.topMargin)
      make.right.equalTo(self.snp.rightMargin).inset(10)
      make.left.equalTo(self.snp.leftMargin)
      make.height.equalTo(self.snp.width).inset(20)
    }
    
    imageView[1].snp.remakeConstraints { (make) in
      make.top.equalTo(self.snp.topMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.left.equalTo(self.snp.leftMargin).inset(10)
      make.height.equalTo(self.snp.width).inset(20)
    }
    
    titleLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(imageView[0].snp.bottom).offset(10)
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.bottom.equalTo(divideLine.snp.top)
    }
    
    cheeseIconImg.snp.remakeConstraints { (make) in
      make.top.equalToSuperview().offset(8)
      make.left.equalToSuperview()
      make.height.equalTo(70)
      make.width.equalTo(70)
    }
    
    peopleImg.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin).offset(10)
      make.top.equalTo(divideLine).offset(25)
    }
    
    peopleCount.snp.remakeConstraints { (make) in
      make.left.equalTo(self.peopleImg.snp.right).offset(10)
      make.centerY.equalTo(peopleImg)
    }
    
    calendarImg.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.centerX)
      make.centerY.equalTo(peopleImg)
    }
    
    endDateLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(self.calendarImg.snp.right).offset(10)
      make.centerY.equalTo(peopleImg)
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
