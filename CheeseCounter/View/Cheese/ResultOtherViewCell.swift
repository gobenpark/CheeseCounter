//
//  ResultOtherViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import CircleProgressView

class ResultOtherViewCell: UICollectionReusableView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 25)
    label.adjustsFontSizeToFitWidth = true
    label.lineBreakMode = .byTruncatingTail
    label.minimumScaleFactor = 0.5
    label.textColor = .black
    label.numberOfLines = 2
    return label
  }()
  
  let hashTagImage: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_tag@1x"))
    return img
  }()
  
  let hashTagLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 11)
    label.numberOfLines = 2
    label.textColor = .lightGray
    return label
  }()
  
  let graphView = ResultGraphView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(titleLabel)
    self.addSubview(hashTagLabel)
    self.addSubview(graphView)
    self.addSubview(hashTagImage)
    
    
    titleLabel.snp.makeConstraints {(make) in
      make.top.equalToSuperview().offset(20)
      make.left.equalToSuperview().inset(22)
      make.right.equalTo(self.snp.rightMargin)
      make.height.equalTo(50)
    }
    
    hashTagImage.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.height.equalTo(10)
      make.width.equalTo(hashTagImage.snp.height)
      make.left.equalTo(titleLabel)
    }
    
    hashTagLabel.snp.makeConstraints { (make) in
      make.left.equalTo(self.hashTagImage.snp.right).offset(10)
      make.right.equalTo(self.snp.rightMargin)
      make.centerY.equalTo(hashTagImage)
    }
    
    graphView.snp.makeConstraints { (make) in
      make.top.equalTo(hashTagImage.snp.bottom).offset(10)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  func graphDataUpdate(cheeseData:CheeseResult){
    
    self.titleLabel.text = cheeseData.cheeseData.title
    self.hashTagLabel.text = "#"+(cheeseData.cheeseData.hash_tag.replacingOccurrences(of: " ", with: "#"))
    guard let type = cheeseData.cheeseData.type else {return}
    
    if type == "2"{
      secondSetting(cheeseData: cheeseData)
    }else if cheeseData.cheeseData.type == "4"{
      fourSetting(cheeseData: cheeseData)
    }
  }
  
  
  fileprivate func secondSetting(cheeseData: CheeseResult){
    
    self.graphView.type = "2"
    self.graphView.subLabels[0].text = cheeseData.cheeseData.ask1
    self.graphView.subLabels[1].text = cheeseData.cheeseData.ask2
    let attribute = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 0).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    attribute.append(NSAttributedString(string: "%"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    
    self.graphView.circleViews[0].percentLabel.attributedText = attribute
    let attribute1 = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 1).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    
    attribute1.append(NSAttributedString(string: "%", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    self.graphView.circleViews[1].percentLabel.attributedText = attribute1
    
    self.graphView.circleViews[0].circleProgressView.progress = (cheeseData.getPercent(number: 0))/100
    self.graphView.circleViews[1].circleProgressView.progress = (cheeseData.getPercent(number: 1))/100
  }
  
  fileprivate func fourSetting(cheeseData: CheeseResult){
    self.graphView.type = "4"
    self.graphView.subLabels[0].text = cheeseData.cheeseData.ask1
    self.graphView.subLabels[1].text = cheeseData.cheeseData.ask2
    let attribute = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 0).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    attribute.append(NSAttributedString(string: "%"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    
    self.graphView.circleViews[0].percentLabel.attributedText = attribute
    let attribute1 = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 1).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    
    attribute1.append(NSAttributedString(string: "%", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    self.graphView.circleViews[1].percentLabel.attributedText = attribute1
    
    self.graphView.circleViews[0].circleProgressView.progress = (cheeseData.getPercent(number: 0))/100
    self.graphView.circleViews[1].circleProgressView.progress = (cheeseData.getPercent(number: 1))/100
    
    self.graphView.subLabels[2].text = cheeseData.cheeseData.ask3
    self.graphView.subLabels[3].text = cheeseData.cheeseData.ask4
    
    let attribute2 = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 2).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    attribute2.append(NSAttributedString(string: "%"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    
    let attribute3 = NSMutableAttributedString(string: "\(cheeseData.getPercent(number: 3).roundToPlaces(places: 1))"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 40)])
    attribute3.append(NSAttributedString(string: "%"
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24)]))
    
    self.graphView.circleViews[2].percentLabel.attributedText = attribute2
    self.graphView.circleViews[3].percentLabel.attributedText = attribute3
    
    self.graphView.circleViews[2].circleProgressView.progress = (cheeseData.getPercent(number: 2))/100
    self.graphView.circleViews[3].circleProgressView.progress = (cheeseData.getPercent(number: 3))/100

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class ResultGraphView: UIView {
  
  let circleViews: [CircleView] = {
    let colors = [#colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1),#colorLiteral(red: 0.5923877358, green: 0.8875928521, blue: 0.3789092302, alpha: 1),#colorLiteral(red: 0.9329745173, green: 0.3933187127, blue: 0.7488761544, alpha: 1),#colorLiteral(red: 0.4226758778, green: 0.7605102658, blue: 0.9478487372, alpha: 1)]
    var views: [CircleView] = []
    for i in 0...3{
      let view = CircleView()
      view.circleProgressView.trackFillColor = colors[i]
      view.tag = i+1
      view.circleProgressView.trackBorderColor = .white
      views.append(view)
    }
    return views
  }()
  
  
  let subLabels: [UILabel] = {
    var labels: [UILabel] = []
    for i in 0...3{
      let label = UILabel()
      label.textAlignment = .center
      label.font = UIFont.systemFont(ofSize: 19)
      label.adjustsFontSizeToFitWidth = true
      label.lineBreakMode = .byTruncatingTail
      label.minimumScaleFactor = 0.5
      label.textColor = .black
      label.numberOfLines = 2
      labels.append(label)
    }
    return labels
  }()
  
  var type: String?{
    didSet{
      self.layoutUpdate()
      setNeedsUpdateConstraints()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    circleViews.forEach {[weak self] (view) in
      self?.addSubview(view)
    }
    
    subLabels.forEach {[weak self] (label) in
      self?.addSubview(label)
    }
    
    backgroundColor = .clear
  }
  
  fileprivate func layoutUpdate(){
    let width = UIScreen.main.bounds.width/2
    
    
    
    if (type ?? "0") == "2"{
      circleViews[0].snp.remakeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
        make.left.equalToSuperview()
        make.height.equalTo(width)
      }
      
      subLabels[0].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[0].snp.bottom).offset(10)
        make.left.equalTo(circleViews[0])
        make.right.equalTo(circleViews[0])
        make.height.equalTo(50)
      }
      
      circleViews[1].snp.remakeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalToSuperview()
        make.left.equalTo(self.circleViews[0].snp.right)
        make.height.equalTo(width)
      }
      
      subLabels[1].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[1].snp.bottom).offset(10)
        make.left.equalTo(circleViews[1])
        make.right.equalTo(circleViews[1])
        make.height.equalTo(50)
      }
      
      
      subLabels[2].snp.removeConstraints()
      subLabels[3].snp.removeConstraints()
      circleViews[2].snp.removeConstraints()
      circleViews[3].snp.removeConstraints()
      subLabels[2].removeFromSuperview()
      subLabels[3].removeFromSuperview()
      circleViews[2].removeFromSuperview()
      circleViews[3].removeFromSuperview()
      
    }else{
      
      circleViews[0].snp.remakeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
        make.left.equalToSuperview()
        make.height.lessThanOrEqualTo(width)
      }
      
      subLabels[0].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[0].snp.bottom).offset(10)
        make.left.equalTo(circleViews[0])
        make.right.equalTo(circleViews[0])
        make.height.equalTo(50)
      }
      
      circleViews[1].snp.remakeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalToSuperview()
        make.left.equalTo(self.circleViews[0].snp.right)
        make.height.equalTo(circleViews[0])
      }
      
      subLabels[1].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[1].snp.bottom).offset(10)
        make.left.equalTo(circleViews[1])
        make.right.equalTo(circleViews[1])
        make.height.equalTo(50)
      }
      
      circleViews[2].snp.remakeConstraints({ (make) in
        make.top.equalTo(subLabels[0].snp.bottom).offset(10)
        make.left.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
        make.height.equalTo(circleViews[0])
      })
      
      subLabels[2].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[2].snp.bottom).offset(10)
        make.left.equalTo(circleViews[2])
        make.right.equalTo(circleViews[2])
        make.bottom.equalToSuperview()
      }
      
      circleViews[3].snp.remakeConstraints({ (make) in
        make.centerY.equalTo(circleViews[2])
        make.right.equalToSuperview()
        make.left.equalTo(circleViews[2].snp.right)
        make.height.equalTo(circleViews[0])
      })
      
      subLabels[3].snp.remakeConstraints { (make) in
        make.top.equalTo(circleViews[3].snp.bottom).offset(10)
        make.left.equalTo(circleViews[3])
        make.right.equalTo(circleViews[3])
        make.bottom.equalToSuperview()
      }
    }
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
