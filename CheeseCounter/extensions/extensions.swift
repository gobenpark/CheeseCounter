//
//  extensions.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 2. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import YLGIFImage


extension UIColor{
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  static func cheeseColor() -> UIColor{
    return UIColor.white
    
  }
}

extension UIView {
  
  func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
    
    anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
  }
  
  func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
    
    _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
  }
  
  func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false
    
    var anchors = [NSLayoutConstraint]()
    
    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
    }
    
    if let left = left {
      anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
    }
    
    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
    }
    
    if let right = right {
      anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
    }
    
    if widthConstant > 0 {
      anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
    }
    
    if heightConstant > 0 {
      anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
    }
    
    anchors.forEach({$0.isActive = true})
    
    return anchors
  }
  
}


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


extension String
{
  func encodeUrl() -> String
  {
    return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
  }
  
  func boundingRect(with size: CGSize, attributes: [String: AnyObject]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }
  
  func getUrlWithEncoding() -> String{
    if self.contains("/img/") && !self.isEmpty{
      let index = self.index(self.startIndex, offsetBy: 5)
      let encodedUrl = self.substring(from: index).encodeUrl()
      return UserService.imgString+"/img/"+encodedUrl
    }else if self.contains("/baseImg/") && !self.isEmpty{
      let index = self.index(self.startIndex, offsetBy: 9)
      let encodedUrl = self.substring(from: index).encodeUrl()
      return UserService.imgString+"/baseImg/"+encodedUrl
    }
    return ""
  }
  
  func getDynamicLink() -> String{
    
    return "https://x3exr.app.goo.gl/?link=https://www.cheesecounter.co.kr/cheese?survey=\(self)&apn=com.xiilab.servicedev.cheesecounter&isi=1235147317&ibi=com.xiilab.CheeseCounter&osl=https://x3exr.app.goo.gl/UDPG&fpbin=CJsFEPcCGgVrby1LUg==&cpt=cp&plt=1274&uit=1051&fpbin=CJsFEPcCGgVrby1LUg==&cpt=cp&plt=1274&uit=98318"
  }
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
//  func startLoading(){
//    let activityIndicator = YLImageView(image: YLGIFImage(imageLiteralResourceName: "cheese_test"))
//    activityIndicator.center = self.center
//    activityIndicator.startAnimating()
//    self.addSubview(activityIndicator)
//  }
//  
//  func stopLoading(){
//    
//  }
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
  
}

extension UIImage{
  static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
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

extension Double {
  func roundToPlaces(places:Int) -> Double{
    let divisor = pow(10.0,Double(places))
    return Darwin.round(self * divisor) / divisor
  }
}

extension Int {
  func stringFormattedWithSeparator() -> String  {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
}


