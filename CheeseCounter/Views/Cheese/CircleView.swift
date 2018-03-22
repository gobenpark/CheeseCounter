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
    progressView.progressBarWidth = 13
    progressView.progressBarProgressColor = .yellow
    progressView.progressBarTrackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    progressView.hintHidden = true
    progressView.startAngle = -90.0
    return progressView
  }()
  
  
  let circleLabel: UILabel = {
    let label = UILabel()
    label.contentMode = .center
    label.numberOfLines = 2
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(circleProgressView)
    addSubview(circleLabel)
    addConstraint()
  }
  
  private func addConstraint(){
    circleProgressView.snp.remakeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    circleLabel.snp.remakeConstraints { (make) in
      make.center.equalToSuperview()
    }

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
