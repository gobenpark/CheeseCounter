//
//  CircleView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 7..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import CircleProgressView

class CircleView: UIView{
  
  let circleProgressView: CircleProgressView = {
    let progressView = CircleProgressView()
    progressView.trackWidth = 13
    progressView.centerFillColor = .clear
    progressView.trackFillColor = .yellow
    progressView.backgroundColor = .clear
    progressView.trackBackgroundColor = .clear
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
