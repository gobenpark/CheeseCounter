//
//  SpinWheelWedge.swift
//  wheelsample
//
//  Created by xiilab on 2018. 1. 3..
//  Copyright © 2018년 bumwoo. All rights reserved.
//

import UIKit

open class SpinWheelWedge: UIView {
  public var shape: SpinWheelWedgeShape = SpinWheelWedgeShape()
  public var image: SpinWheelWedgeImageView = SpinWheelWedgeImageView()
  public var point: SpinWheelPointView = SpinWheelPointView()
}

open class SpinWheelWedgeShape: CAShapeLayer {
  
  private func setDefaultValues() {
    self.strokeColor = UIColor.white.cgColor
    self.lineWidth = 1
  }
  
  @objc public func configureWedgeShape(index: UInt, radius: CGFloat, position: CGPoint, degreesPerWedge: Degrees) {
    self.path = createWedgeShapeBezierPath(index: index, radius: radius, position: position, degreesPerWedge: degreesPerWedge).cgPath
    
    setDefaultValues()
  }
  
  private func createWedgeShapeBezierPath(index: UInt, radius: CGFloat, position: CGPoint, degreesPerWedge: Degrees) -> UIBezierPath {
    let newWedgePath: UIBezierPath = UIBezierPath()
    newWedgePath.move(to: position)
    
    let startRadians: Radians = CGFloat(index) * degreesPerWedge * CGFloat.pi / 180
    let endRadians: Radians = CGFloat(index + 1) * degreesPerWedge * CGFloat.pi / 180
    
    newWedgePath.addArc(withCenter: position, radius: radius, startAngle: startRadians, endAngle: endRadians, clockwise: true)
    newWedgePath.close()
    
    return newWedgePath
  }
}


open class SpinWheelWedgeImageView: UIImageView{
  private func setDefaultValues(){
//    self.transform = CGAffineTransform(scaleX: 1, y: -1)
  }
  
  public func configureWedgeImage(index: Int , position: CGPoint, radiansPerWedge: Radians){
    self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    self.layer.anchorPoint = CGPoint(x: 2.4, y: 0.6)
    self.layer.position = position
    self.transform = CGAffineTransform(rotationAngle: radiansPerWedge * CGFloat(index) + CGFloat.pi + (radiansPerWedge / 2))
    self.setDefaultValues()
  }
}

open class SpinWheelPointView: UIImageView{
  
  private func setDefaultValues(){
    //    self.transform = CGAffineTransform(scaleX: 1, y: -1)
  }
  
  public func configureWedgeImage(index: Int , position: CGPoint, radiansPerWedge: Radians, totalCount: UInt){
    
    self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//    self.layer.anchorPoint = CGPoint(x: 16.5, y: 0.5)
    if totalCount == 7{
      self.layer.anchorPoint = CGPoint(x: 14.9, y: 7.5)
    }else if totalCount == 6{
      self.layer.anchorPoint = CGPoint(x: 14.5, y: 8.5)
    }else if totalCount == 5{
      self.layer.anchorPoint = CGPoint(x: 13.5, y: 10)
    }
    self.layer.position = position
    self.transform = CGAffineTransform(rotationAngle: radiansPerWedge * CGFloat(index) + CGFloat.pi + (radiansPerWedge / 2))
    self.setDefaultValues()
  }
}
