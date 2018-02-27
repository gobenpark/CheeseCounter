////
////  CarouselBaseCell.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 3. 29..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//enum badgeImageType:String{
//  case gold
//  case cheese
//
//  var imgString:String {
//    switch self {
//    case .gold:
//      return "badge_gold_left"
//    case .cheese:
//      return "badge_cheese_left"
//    }
//  }
//}
//
//class CarouselBaseCell: UICollectionViewCell {
//
//  let endDateLabel: UILabel = {
//    let label = UILabel()
//    label.textColor = .lightGray
//    label.font = UIFont.systemFont(ofSize: 13)
//    label.sizeToFit()
//    return label
//  }()
//
//  let peopleCount: UILabel = {
//    let label = UILabel()
//    label.textColor = .lightGray
//    label.font = UIFont.systemFont(ofSize: 13)
//    label.sizeToFit()
//    return label
//  }()
//
//  let titleLabel: UILabel = {
//    let label = UILabel()
//    label.font = UIFont.CheeseFontLight(size: 20)
//    label.adjustsFontSizeToFitWidth = true
//    label.lineBreakMode = .byTruncatingTail
//    label.minimumScaleFactor = 0.5
//    label.textColor = .black
//    label.numberOfLines = 2
//    label.textColor = .black
//    return label
//  }()
//
//  let divideLine: UIView = {
//    let view = UIView()
//    view.backgroundColor = .lightGray
//    return view
//  }()
//
//  lazy var cheeseIconImg: CheeseImageView = {
//    let img = CheeseImageView(image: UIImage(named: "badge_gold_left"))
//    return img
//  }()
//
//  let peopleImg: UIImageView = {
//    let img = UIImageView(image: #imageLiteral(resourceName: "icon_person@1x").withRenderingMode(.alwaysTemplate))
//    img.tintColor = .lightGray
//    return img
//  }()
//
//  let calendarImg: UIImageView = {
//    let img = UIImageView(image: #imageLiteral(resourceName: "icon_calendar@1x").withRenderingMode(.alwaysTemplate))
//    img.tintColor = .lightGray
//    return img
//  }()
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//
//    backgroundColor = UIColor.white
//    self.layer.borderWidth = 0.5
//    self.layer.borderColor = UIColor.lightGray.cgColor
//
//    addSubview(endDateLabel)
//    addSubview(peopleCount)
//    addSubview(titleLabel)
//    addSubview(peopleImg)
//    addSubview(calendarImg)
//    addSubview(divideLine)
//
//    divideLine.snp.makeConstraints { (make) in
//      make.left.equalTo(titleLabel)
//      make.right.equalTo(titleLabel)
//      make.bottom.equalToSuperview().inset(60)
//      make.height.equalTo(0.5)
//    }
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  class CheeseImageView:UIImageView {
//
//    var badgeType: badgeImageType = .gold {
//      didSet{
//        self.image = UIImage(named: badgeType.imgString)
//      }
//    }
//
//    let pointLabel: UILabel = {
//      let label = UILabel()
//      label.sizeToFit()
//      label.textColor = .white
//      label.font = UIFont.CheeseFontMedium(size: 14)
//      return label
//    }()
//    override init(image: UIImage?) {
//      super.init(image: image)
//
//      addSubview(pointLabel)
//      pointLabel.snp.makeConstraints({ (make) in
//        make.bottom.equalToSuperview().inset(13)
//        make.centerX.equalToSuperview().inset(-4)
//      })
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//    }
//  }
//}

