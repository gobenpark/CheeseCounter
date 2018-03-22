//
//  CouponHistoryCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import AnyDate
import RxSwift
import RxCocoa

class CouponHistoryCell: UICollectionViewCell{
  
  var viewController: CouponHistoryViewController?
  let disposeBag = DisposeBag()
  
  var model: CouponHistoryViewModel.Item?{
    didSet{
      image.kf.setImage(with: URL(string: (model?.img_url ?? String()).getUrlWithEncoding()))
      titleLabel.text = model?.brand
      contentLabel.text = model?.title
      guard let date = dateConvert(model: model) else {return}
      dateLabel.text = "당첨 일시: \(date)"
    }
  }
  
  let image: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    label.font = UIFont.CheeseFontMedium(size: 12)
    return label
  }()
  
  let contentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 10)
    return label
  }()
  
  let dotLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  let couponImage: UIImageView = {
    let image = UIImageView(image: #imageLiteral(resourceName: "btnCoupon"))
    image.isUserInteractionEnabled = true
    return image
  }()
  
  let couponButton: UIButton = {
    let button = UIButton()
    button.setTitle("쿠폰받기", for: .normal)
    button.setTitle("받기완료", for: .selected)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .selected)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 10)
    button.isUserInteractionEnabled = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(image)
    contentView.addSubview(titleLabel)
    contentView.addSubview(contentLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(dotLine)
    contentView.addSubview(couponImage)
    contentView.addSubview(couponButton)
    
    let coupon = couponImage.rx.tapGesture().asObservable()
    let button = couponButton.rx.tap.asObservable()
    
    Observable.combineLatest(coupon, button) { _,_ in
      return ()
      }
      .map { [unowned self] in
        return self.model
      }.subscribe (onNext:{[weak self] (data) in
        guard let `self` = self else {return}
        self.viewController?.couponClick.value = data
    }).disposed(by: disposeBag)
    
    addConstraint()
  }
  
  private func addConstraint(){
    image.snp.makeConstraints { (make) in
      make.top.bottom.left.equalToSuperview().inset(5)
      make.width.equalTo(image.snp.height)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(10)
      make.left.equalTo(image.snp.right).offset(10)
    }
    
    contentLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(titleLabel)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel)
      make.top.equalTo(contentLabel.snp.bottom).offset(10)
    }
    
    dotLine.snp.makeConstraints { (make) in
      make.bottom.top.equalToSuperview()
      make.width.equalTo(0.5)
      make.right.equalToSuperview().inset(100)
    }
    
    couponImage.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(30)
      make.right.equalToSuperview().inset(40)
    }
    
    couponButton.snp.makeConstraints { (make) in
      make.centerX.equalTo(couponImage)
      make.top.equalTo(couponImage.snp.bottom).offset(5)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let layer = CALayer()
    layer.backgroundColor = UIColor.lightGray.cgColor
    layer.frame = CGRect(x: 0, y: self.contentView.bounds.height - 0.5, width: self.contentView.bounds.width, height: 0.5)
    self.contentView.layer.addSublayer(layer)
  }
  
  private func dateConvert(model: GiftListModel.Data?) -> String?{
    guard let mainModel = model?.update_date else {return nil}
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    guard let startTime = ZonedDateTime.parse(mainModel, formatter: dateFormatter) else {return nil}
    return "\(startTime.year-2000)-\(startTime.month)-\(startTime.day)"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

