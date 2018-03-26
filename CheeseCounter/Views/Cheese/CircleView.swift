//
//  CircleView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 7..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import CircleProgressBar

class CircleView: UIView{
  
  let circleProgressView: CircleProgressBar = {
    let progressView = CircleProgressBar()
    progressView.backgroundColor = .clear
    progressView.progressBarWidth = 9
    progressView.progressBarProgressColor = .yellow
    progressView.progressBarTrackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    progressView.startAngle = -90.0
    
    
    progressView.hintViewBackgroundColor = .clear
    
    
    return progressView
  }()
  
  
//  let circleLabel: UILabel = {
//    let label = UILabel()
//    label.contentMode = .center
//    label.numberOfLines = 2
//    label.textColor = .white
//    return label
//  }()
  
  let circleLabel: UILabel = {
    let label = UILabel()
    label.contentMode = .center
    label.numberOfLines = 1
    label.textColor = .white
    label.text = "자세히 보기"
    label.font = UIFont.CheeseFontRegular(size: 8.1)
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(circleProgressView)
    circleProgressView.addSubview(circleLabel)
    //addSubview(circleLabel)
    addConstraint()
  }
  
  private func addConstraint(){
    circleProgressView.snp.remakeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    circleLabel.snp.remakeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(25)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
