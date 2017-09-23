//
//  ListDetailTitleCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 2..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class ListDetailTitleCell: UICollectionViewCell{
  
  override var tag: Int{
    didSet{
      switch tag{
      case 1:
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_1_select"), for: .selected)
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_1"), for: .normal)
      case 2:
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_2"), for: .normal)
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_2_select"), for: .selected)
      case 3:
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_3"), for: .normal)
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_3_select"), for: .selected)
      case 4:
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_4"), for: .normal)
        self.rankImageView.setImage(#imageLiteral(resourceName: "ic_rank_4_select"), for: .selected)
      default:
        break
      }
    }
  }
  
  override var isSelected: Bool{
    didSet{
      self.rankImageView.isSelected = isSelected
    }
  }
    
  let rankImageView: UIButton = {
    let imgView = UIButton()
    return imgView
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    return label
  }()
  
  let countLabel: UILabel = {
    let label = UILabel()
    label.text = "0"
    label.font = UIFont.CheeseFontBold(size: 20)
    label.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    label.textAlignment = .right
    return label
  }()
  
  let dividView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.backgroundColor = .white
    self.contentView.addSubview(rankImageView)
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(dividView)
    self.contentView.addSubview(countLabel)
    
    self.rankImageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(22)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
      make.width.equalTo(rankImageView.snp.height)
    }
    
    self.titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.left.equalTo(rankImageView.snp.right).offset(10)
      make.right.equalTo(countLabel.snp.left)
    }
    
    countLabel.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.equalTo(50)
    }
    
    
    self.dividView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(22)
      make.bottom.equalToSuperview()
      make.height.equalTo(0.5)
      make.right.equalToSuperview().inset(22)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


