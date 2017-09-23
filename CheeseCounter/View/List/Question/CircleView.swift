//
//  CircleProgressView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 8..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import CircleProgressView

class CircleView: UIView
{
  let percentLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.clear
    label.textAlignment = .center
    label.textColor = .black
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.numberOfLines = 1
    return label
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "자세히보기"
    label.font = UIFont.CheeseFontLight(size: 13)
    label.textColor = .lightGray
    return label
  }()
  
  let circleProgressView: CircleProgressView = {
    let progressView = CircleProgressView()
    progressView.trackWidth = 5
    progressView.centerFillColor = UIColor.cheeseColor()
    progressView.progress = 0.0
    progressView.trackFillColor = .yellow
    progressView.backgroundColor = .clear
    return progressView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(circleProgressView)
    backgroundColor = .clear
    circleProgressView.addSubview(percentLabel)
    circleProgressView.addSubview(detailLabel)
    addContraint()
  }
  
  func rankTextConfigure(stringAttribute:NSAttributedString...){
    let attributedText = NSMutableAttributedString()
    stringAttribute.forEach {
      attributedText.append($0)
    }
    percentLabel.attributedText = attributedText
  }
  
  func addContraint()
  {
    circleProgressView.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.8)
      make.width.equalTo(circleProgressView.snp.height)
    }
    
    percentLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(circleProgressView).inset(10)
      make.right.equalTo(circleProgressView).inset(10)
      make.centerX.equalTo(circleProgressView)
      make.centerY.equalTo(circleProgressView)
    }
    
    detailLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(percentLabel.snp.bottom)
      make.centerX.equalTo(percentLabel)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
