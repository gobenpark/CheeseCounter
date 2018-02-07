//
//  CircleView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 7..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import CircleProgressView

class CircleView2: UIView{
  
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
//    view.circleProgressView.trackFillColor = colors[i]
//    view.tag = i+1
//    view.circleProgressView.trackBorderColor = .white
    addConstraint()
  }
  
  private func addConstraint(){
    circleProgressView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
