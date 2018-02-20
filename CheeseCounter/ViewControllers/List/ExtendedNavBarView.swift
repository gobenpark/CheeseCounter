//
//  ExtendedNavBarView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation

import BetterSegmentedControl



class ExtendedNavBarView: UIView {
  

  var titles: [String] = []{
    didSet{
      self.segmentedControl.titles = titles
    }
  }
  
  lazy var segmentedControl: BetterSegmentedControl = {
    
    let sc = BetterSegmentedControl(frame: .zero, titles: ["질문","응답","공감"], index: 0, options: [
      .backgroundColor(.white)
      ,.titleColor(.lightGray)
      ,.indicatorViewBackgroundColor(UIColor(gradientStyle: .leftToRight
        , withFrame: CGRect(x: 0, y: 0, width: 200, height: 40), andColors: [#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)]))
      ,.selectedTitleColor(.white)
      ,.cornerRadius(20)])

    sc.layer.borderWidth = 0.5
    sc.layer.borderColor = UIColor.lightGray.cgColor
    sc.titleFont = UIFont.CheeseFontMedium(size: 14)
    return sc
  }()
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    addSubview(segmentedControl)

    let bottomView = UIView()
    bottomView.backgroundColor = #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1)
    self.addSubview(bottomView)
    
    bottomView.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(2)
    }
    
    segmentedControl.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(30)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
      make.right.equalToSuperview().inset(30)
    }
  }
}
