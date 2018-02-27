////
////  CarouselCell4.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 3. 29..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//class CarouselCell4: CarouselBaseCell{
//  
//  var data: CheeseResultByDate.Data?{
//    didSet{
//      var urlString1 = data?.ask1_img_url ?? ""
//      var urlString2 = data?.ask2_img_url ?? ""
//      var urlString3 = data?.ask3_img_url ?? ""
//      var urlString4 = data?.ask4_img_url ?? ""
//      
//      if urlString1 == "" {
//        urlString1 = "/img/default1.png"
//        data?.ask1_img_url = urlString1
//      }
//      if urlString2 == ""{
//        urlString2 = "/img/default2.png"
//        data?.ask2_img_url = urlString2
//      }
//      if urlString3 == ""{
//        urlString3 = "/img/default3.png"
//        data?.ask3_img_url = urlString3
//      }
//      if urlString4 == ""{
//        urlString4 = "/img/default4.png"
//        data?.ask4_img_url = urlString4
//      }
//      
//      imageView[0].kf.setImage(with: URL(string: urlString1.getUrlWithEncoding()))
//      imageView[1].kf.setImage(with: URL(string: urlString2.getUrlWithEncoding()))
//      imageView[2].kf.setImage(with: URL(string: urlString3.getUrlWithEncoding()))
//      imageView[3].kf.setImage(with: URL(string: urlString4.getUrlWithEncoding()))
//      
//      self.endDateLabel.text = (data?.limit_date?.components(separatedBy: " ")[0] ?? "")
//        .replacingOccurrences(of: "-", with: "/")
//      self.peopleCount.text = data?.total_count
//      self.titleLabel.text = data?.title
//      self.cheeseIconImg.pointLabel.text = data?.option_cut_cheese ?? ""
//      guard let option = data?.is_option else {return}
//      if option == "1"{
//        self.peopleCount.text = (data?.total_count ?? "")+"/"+(data?.option_set_count ?? "")
//        self.cheeseIconImg.badgeType = .gold
//      } else {
//        self.peopleCount.text = data?.total_count ?? ""
//        self.cheeseIconImg.badgeType = .cheese
//      }
//    }
//  }
//  
//  let imageView:[UIImageView] = {
//    var iv = [UIImageView]()
//    for _ in 0...3 {
//      let img = UIImageView()
//      img.contentMode = .scaleAspectFill
//      img.layer.masksToBounds = true
//      img.layer.borderWidth = 0.5
//      img.layer.borderColor = UIColor.lightGray.cgColor
//      iv.append(img)
//    }
//    return iv
//  }()
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    
//    for view in imageView {
//      addSubview(view)
//    }
//    
//    for imgView in imageView{
//      imgView.kf.indicatorType = .activity
//    }
//    
//    self.addSubview(cheeseIconImg)
//    
//    imageView[0].snp.makeConstraints { (make) in
//      make.top.equalTo(self.snp.topMargin)
//      make.left.equalTo(self.snp.leftMargin)
//      make.right.equalTo(self.snp.centerX).inset(-5)
//      make.height.equalTo(imageView[0].snp.width)
//    }
//    
//    imageView[1].snp.makeConstraints { (make) in
//      make.top.equalTo(imageView[0])
//      make.right.equalTo(self.snp.rightMargin)
//      make.left.equalTo(self.snp.centerX).inset(5)
//      make.height.equalTo(imageView[1].snp.width)
//    }
//    
//    imageView[2].snp.makeConstraints { (make) in
//      make.top.equalTo(self.imageView[0].snp.bottom).offset(10)
//      make.left.equalTo(self.imageView[0])
//      make.right.equalTo(self.snp.centerX).inset(-5)
//      make.height.equalTo(imageView[2].snp.width)
//    }
//    
//    imageView[3].snp.makeConstraints { (make) in
//      make.top.equalTo(self.imageView[2])
//      make.right.equalTo(self.snp.rightMargin)
//      make.left.equalTo(self.snp.centerX).inset(5)
//      make.height.equalTo(imageView[3].snp.width)
//    }
//    
//    titleLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(imageView[2].snp.bottom).offset(10)
//      make.left.equalTo(self.snp.leftMargin)
//      make.right.equalTo(self.snp.rightMargin)
//      make.bottom.equalTo(self.divideLine.snp.top)
//    }
//    
//    divideLine.snp.remakeConstraints { (make) in
//      make.left.equalTo(titleLabel)
//      make.right.equalTo(titleLabel)
//      make.bottom.equalToSuperview().inset(30)
//      make.height.equalTo(0.5)
//    }
//    
//    cheeseIconImg.snp.makeConstraints { (make) in
//      make.top.equalToSuperview().offset(8)
//      make.left.equalToSuperview()
//      make.height.equalTo(70)
//      make.width.equalTo(70)
//    }
//    
//    peopleImg.snp.makeConstraints { (make) in
//      make.left.equalTo(self.snp.leftMargin)
//      make.centerY.equalTo(peopleCount)
//    }
//    
//    peopleCount.snp.makeConstraints { (make) in
//      make.left.equalTo(self.peopleImg.snp.right).offset(20)
//      make.top.equalTo(divideLine)
//      make.bottom.equalToSuperview()
//    }
//    
//    calendarImg.snp.makeConstraints { (make) in
//      make.left.equalTo(self.snp.centerX)
//      make.centerY.equalTo(peopleCount)
//    }
//    
//    endDateLabel.snp.makeConstraints { (make) in
//      make.left.equalTo(self.calendarImg.snp.right).offset(20)
//      make.centerY.equalTo(peopleCount)
//    }
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}

