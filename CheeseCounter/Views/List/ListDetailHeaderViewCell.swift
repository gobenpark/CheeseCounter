//
//  ListDetailHeaderViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 2..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class ListDetailHeaderViewCell: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.font = UIFont.CheeseFontBold(size: 17)
    label.textAlignment = .left
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ListDetailFooterView: UICollectionReusableView{
  
  let foldButton: UIButton = {
    let button = UIButton()
    button.setTitle("접기", for: .selected)
    button.setTitle("더보기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1), for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 10)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(foldButton)
    self.backgroundColor = .white 
    foldButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
