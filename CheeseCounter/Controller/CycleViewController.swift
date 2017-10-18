//
//  CycleViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 10. 18..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

struct Segment{
  var color: UIColor
  
  var value: CGFloat
}


class CycleViewController: UIViewController{
  
  var p = CGPoint.zero
  
  let pieView = PieView(frame: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(pieView)
    
    pieView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.equalTo(200)
      make.width.equalTo(200)
    }
    
    pieView.segments = [Segment(color: .blue, value: 0.8),Segment(color: .red, value: 0.2)]
  }
  
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let dev = p.y - (touches.first?.location(in: self.view).y)!
    let angle = 2 * .pi - atan(dev / p.y)
    self.pieView.transform = CGAffineTransform(rotationAngle: angle)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let point = touches.first?.location(in: self.view) else {return}
    p = point
  }
}

class PieView: UIView{
  
  var segments = [Segment]() {
    didSet {
      setNeedsDisplay() // re-draw view when the values get set
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isOpaque = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    let radius = min(frame.size.width, frame.size.height) * 0.5
    
    let viewCenterPoint = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    
    let valueCount = segments.reduce(0, {$0 + $1.value})
    var startAngle = -CGFloat.pi * 0.5
    
    for segment in segments{
      context?.setFillColor(segment.color.cgColor)
      
      let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
      context?.move(to: viewCenterPoint)
      context?.addArc(center: viewCenterPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
      context?.fillPath()
      startAngle = endAngle
    }
    
    
  }
}


