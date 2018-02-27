//
//  GiftItemViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Kingfisher

final class GiftItemViewCell: UICollectionViewCell {
  
  var item: GiftModel.Result.Data?{
    didSet{
      brandLabel.text = item?.brand
      productLabel.text = item?.title
      
      if let url = item?.imageURL{
        imageView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(brandLabel)
    contentView.addSubview(productLabel)
    addConstraint()
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
  }
}
