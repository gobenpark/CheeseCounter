//
//  GiftItemViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class GiftItemViewCell: UICollectionViewCell {
  let disposeBag = DisposeBag()
  let disableView = UIView()
  var item: GiftModel.Result.Data?{
    didSet{
      brandLabel.text = item?.brand
      productLabel.text = item?.title
      
      if let url = item?.imageURL{
        imageView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
      }
      
      cheeseButton.setTitle(item?.buyPoint, for: .normal)
      
      if item?.coupon_count == nil || item?.coupon_count == "0"{
        disableView.backgroundColor = .black
        disableView.alpha = 0.5
        self.addSubview(disableView)
        disableView.snp.makeConstraints({ (make) in
          make.edges.equalTo(imageView)
        })
      }else{
        disableView.removeFromSuperview()
        disableView.snp.removeConstraints()
      }
      
      defer {
        brandLabel.sizeToFit()
        productLabel.sizeToFit()
      }
    }
  }
  
  let imageView: UIImageView = {
    let image = UIImageView()
    image.layer.borderWidth = 0.5
    image.layer.borderColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return image
  }()
  
  let brandLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 10)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let productLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 11.9)
    label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    return label
  }()
  
  let cheeseButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icGiftCheese"), for: .normal)
    button.semanticContentAttribute = .forceLeftToRight
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 10.4)
    button.setTitleColor(#colorLiteral(red: 1, green: 0.4901960784, blue: 0.3176470588, alpha: 1), for: .normal)
    button.isHidden = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(brandLabel)
    contentView.addSubview(productLabel)
    contentView.addSubview(cheeseButton)
    addConstraint()
    
    disableView.rx.tapGesture()
      .when(.ended)
      .map{ _ in
        let view = UIAlertController(title: "해당 상품은 모두 소진되었습니다.", message: nil, preferredStyle: .alert)
        view.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        return view
      }.subscribe(onNext:{view in
        AppDelegate.instance?.window?.rootViewController?.present(view, animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraint(){
    
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 0, 5))
    }
    
    brandLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(26)
      make.left.equalTo(imageView.snp.left).inset(8.5)
      make.right.equalToSuperview().inset(9)
    }
    
    productLabel.snp.makeConstraints { (make) in
      make.left.equalTo(brandLabel)
      make.top.equalTo(brandLabel.snp.bottom).offset(2.5)
      make.right.equalTo(imageView.snp.right).inset(4.5)
    }
    
    cheeseButton.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(9)
      make.right.equalToSuperview().inset(9)
    }
  }
}
