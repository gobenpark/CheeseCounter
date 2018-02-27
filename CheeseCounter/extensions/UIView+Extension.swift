//
//  extensions.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 2. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

func snap(_ x: CGFloat) -> CGFloat {
  let scale = UIScreen.main.scale
  return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
  return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
  return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}


extension UIView
{
  func addParallelogramMaskToView(isTop: Bool)
  {
    if isTop{
      
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: self.bounds.size.width * 0.7,y: 0))
      path.addLine(to: CGPoint(x: self.bounds.size.width * 0.3,y: self.bounds.size.height))
      path.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
      path.close()
      
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path.cgPath
      
      
      let frameLayer = CAShapeLayer()
      frameLayer.path = path.cgPath
      frameLayer.lineWidth = 0.5
      frameLayer.strokeColor = UIColor.lightGray.cgColor
      frameLayer.fillColor = nil
      layer.addSublayer(frameLayer)
      self.layer.mask = shapeLayer
      
    } else {
      
      let path = UIBezierPath()
      path.move(to: CGPoint(x: self.bounds.size.width * 0.3, y: self.bounds.size.height))
      path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
      path.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
      path.addLine(to: CGPoint(x: self.bounds.size.width * 0.7, y: 0))
      path.close()
      
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path.cgPath
      
      let frameLayer = CAShapeLayer()
      frameLayer.path = path.cgPath
      frameLayer.lineWidth = 0.5
      frameLayer.strokeColor = UIColor.lightGray.cgColor
      frameLayer.fillColor = nil
      layer.addSublayer(frameLayer)
      self.layer.mask = shapeLayer
    }
  }

  static let LOADING_VIEW_TAG = 23513
  
  func startLoading() -> Void {
    let loadingView = self.viewWithTag(UIView.LOADING_VIEW_TAG)
    if loadingView == nil {
      let loadingView = UIView.init(frame: self.bounds)
      loadingView.tag = UIView.LOADING_VIEW_TAG
      self.addSubview(loadingView)
      
      let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
      activityIndicator.center = loadingView.center
      activityIndicator.startAnimating()
      loadingView.addSubview(activityIndicator)
      
      loadingView.alpha = 0
      UIView.animate(withDuration: 0.3, animations: {
        loadingView.alpha = 1
      })
    }
  }
  
  func stopLoading() -> Void {
    if let loadingView = self.viewWithTag(UIView.LOADING_VIEW_TAG) {
      UIView.animate(withDuration: 0.3, animations: {
        loadingView.alpha = 0
      }, completion: { (finished) in
        loadingView.removeFromSuperview()
      })
    }
  }
  
  func setTopBorderColor(color: UIColor, height: CGFloat){
    let bottomBorderRect = CGRect(x: 0, y: 0, width: frame.width, height: height)
    let bottomBorderView = UIView(frame: bottomBorderRect)
    bottomBorderView.backgroundColor = color
    addSubview(bottomBorderView)
  }
  
  func setBottomBorderColor(color: UIColor, height: CGFloat) {
    let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
    let bottomBorderView = UIView(frame: bottomBorderRect)
    bottomBorderView.backgroundColor = color
    addSubview(bottomBorderView)
  }
  
  func setBottomBorderColor2(color: UIColor, height: CGFloat) -> UIView {
    let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
    let bottomBorderView = UIView(frame: bottomBorderRect)
    bottomBorderView.backgroundColor = color
    addSubview(bottomBorderView)
    return bottomBorderView
  }
}

extension UIFont{
  static func CheeseFontBold(size: CGFloat) -> UIFont {
    return UIFont(name: "NotoSansKR-Bold", size: size)!
  }
  static func CheeseFontLight(size: CGFloat) -> UIFont {
    return UIFont(name: "NotoSansKR-Light", size: size)!
  }
  static func CheeseFontMedium(size: CGFloat) -> UIFont {
    return UIFont(name: "NotoSansKR-Medium", size: size)!
  }
  static func CheeseFontRegular(size: CGFloat) -> UIFont {
    return UIFont(name: "NotoSansKR-Medium", size: size)!
  }
}

extension UIView {
  public func getSnapshotImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
    self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
    let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return snapshotImage
  }
}



