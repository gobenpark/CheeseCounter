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
//    progressView.progress = 0.5
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
    backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    addSubview(circleProgressView)
    addSubview(circleLabel)
//    view.circleProgressView.trackFillColor = colors[i]
//    view.tag = i+1
//    view.circleProgressView.trackBorderColor = .white
    addConstraint()
  }
  
  private func addConstraint(){
    circleProgressView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    circleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
