//
//  CheeseImageView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 16..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

final class MainSurveyImageView: UIView{
  
  let disposeBag = DisposeBag()
  var model: MainSurveyList.CheeseData?{
    didSet{
      guard let cheeseModel = model else {return}
      
      if let ask = cheeseModel.select_ask{
        selectedColor(of: ask)
      }
      
      addConstraintWithImage(model: cheeseModel)
      resultImageMapper(model: cheeseModel)
    }
  }
  
  let imageButton1 = ImageButton()
  let imageButton2 = ImageButton()
  let imageButton3 = ImageButton()
  let imageButton4 = ImageButton()
  let circleView1 = CircleView()
  let circleView2 = CircleView()
  let circleView3 = CircleView()
  let circleView4 = CircleView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  private func resultImageMapper(model: MainSurveyList.CheeseData){
    guard let surveyResult = model.survey_result else {return}
    if model.type == "2"{
      result2ImageMapper(result: surveyResult)
    }else if model.type == "4"{
      result4ImageMapper(result: surveyResult)
    }
    self.layoutIfNeeded()
    self.setNeedsLayout()
  }
  
  private func result2ImageMapper(result: MainSurveyList.CheeseData.Survey_Result){
    
    if var survey1 = Double(result.ask1_count ?? "0"),
      var survey2 = Double(result.ask2_count ?? "0"){
    
    let total = survey1 + survey2
    
    survey1 = survey1/total
    survey2 = survey2/total
    
    addSubview(circleView1)
    addSubview(circleView2)
    
    circleView1.circleProgressView.progress = survey1
    circleView2.circleProgressView.progress = survey2
    
    circleView2.circleProgressView.trackFillColor = #colorLiteral(red: 0.5810118318, green: 0.8874687552, blue: 0.3601810932, alpha: 1)
    
    circleView1.circleLabel.attributedText = attributeFactory(count: survey1)
    circleView2.circleLabel.attributedText = attributeFactory(count: survey2)
    circleView1.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton1)
    })
    circleView2.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton2)
    })
    }else {
      circleView1.removeFromSuperview()
      circleView2.removeFromSuperview()
    }
  }
  
  private func result4ImageMapper(result: MainSurveyList.CheeseData.Survey_Result){
    
    if var survey1 = Double(result.ask1_count ?? "0") ,
      var survey2 = Double(result.ask2_count ?? "0"),
      var survey3 = Double(result.ask3_count ?? "0"),
      var survey4 = Double(result.ask4_count ?? "0"){
    
    let total = survey1 + survey2 + survey3 + survey4
    
    survey1 = survey1/total
    survey2 = survey2/total
    survey3 = survey3/total
    survey4 = survey4/total
      
    addSubview(circleView1)
    addSubview(circleView2)
    addSubview(circleView3)
    addSubview(circleView4)
    
    circleView1.circleProgressView.progress = survey1
    circleView2.circleProgressView.progress = survey2
    circleView3.circleProgressView.progress = survey3
    circleView4.circleProgressView.progress = survey4
    
    circleView1.circleLabel.attributedText = attributeFactory(count: survey1)
    circleView2.circleLabel.attributedText = attributeFactory(count: survey2)
    circleView3.circleLabel.attributedText = attributeFactory(count: survey3)
    circleView4.circleLabel.attributedText = attributeFactory(count: survey4)
    
    circleView2.circleProgressView.trackFillColor = #colorLiteral(red: 0.5810118318, green: 0.8874687552, blue: 0.3601810932, alpha: 1)
    circleView4.circleProgressView.trackFillColor = #colorLiteral(red: 0.5810118318, green: 0.8874687552, blue: 0.3601810932, alpha: 1)
    
    circleView1.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton1)
    })
    circleView2.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton2)
    })
    circleView3.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton3)
    })
    circleView4.snp.remakeConstraints({ (make) in
      make.edges.equalTo(imageButton4)
    })
    }else{
      circleView1.removeFromSuperview()
      circleView2.removeFromSuperview()
      circleView3.removeFromSuperview()
      circleView4.removeFromSuperview()
    }
  }
  
  private func attributeFactory(count: Double) -> NSMutableAttributedString{
    let attributedStringParagraphStyle = NSMutableParagraphStyle()
    attributedStringParagraphStyle.alignment = NSTextAlignment.center
    
    let attributeString = NSMutableAttributedString(string: "\((count*100).roundToPlaces(places: 1))%\n",
      attributes: [NSAttributedStringKey.font: UIFont.CheeseFontRegular(size: 25.8)])
    attributeString.append(NSAttributedString(
        string: "자세히 보기",
        attributes: [NSAttributedStringKey.font: UIFont.CheeseFontRegular(size: 8.1)
          ,NSAttributedStringKey.paragraphStyle:attributedStringParagraphStyle]))
    return attributeString
  }
  
  private func selectedColor(of number: String){
    if number == "1"{
      circleView1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)
      circleView2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }else if number == "2"{
      circleView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)
      circleView1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }else if number == "3"{
      circleView3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)
      circleView2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }else if number == "4"{
      circleView4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)
      circleView2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
      circleView1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
  }
  
  private func addConstraintWithImage(model: MainSurveyList.CheeseData){
    
    imageButton1.kf.setBackgroundImage(with: URL(string: model.ask1_img_url.getUrlWithEncoding()), for: .normal)
    imageButton2.kf.setBackgroundImage(with: URL(string: model.ask2_img_url.getUrlWithEncoding()), for: .normal)
    
    if model.type == "2"{
      addSubview(imageButton1)
      addSubview(imageButton2)
      
      imageButton1.setTitle(model.ask1, for: .normal)
      imageButton2.setTitle(model.ask2, for: .normal)
      
      imageButton1.snp.remakeConstraints({ (make) in
        make.left.top.bottom.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
      })
    
      imageButton2.snp.remakeConstraints({ (make) in
        make.top.right.bottom.equalToSuperview()
        make.left.equalTo(imageButton1.snp.right)
      })
    }else if model.type == "4"{
      guard let image3URL = model.ask3_img_url
        , let image4URL = model.ask4_img_url else {return}
      
      addSubview(imageButton1)
      addSubview(imageButton2)
      addSubview(imageButton3)
      addSubview(imageButton4)
      
      imageButton1.setTitle(model.ask1, for: .normal)
      imageButton2.setTitle(model.ask2, for: .normal)
      imageButton3.setTitle(model.ask3, for: .normal)
      imageButton4.setTitle(model.ask4, for: .normal)
      
      imageButton3.kf.setBackgroundImage(with: URL(string: image3URL.getUrlWithEncoding()), for: .normal)
      imageButton4.kf.setBackgroundImage(with: URL(string: image4URL.getUrlWithEncoding()), for: .normal)
    
      imageButton1.snp.remakeConstraints({ (make) in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
        make.bottom.equalTo(self.snp.centerY)
      })
      
      imageButton2.snp.remakeConstraints({ (make) in
        make.top.equalToSuperview()
        make.right.equalToSuperview()
        make.left.equalTo(imageButton1.snp.right)
        make.bottom.equalTo(self.snp.centerY)
      })
      
      imageButton3.snp.remakeConstraints({ (make) in
        make.top.equalTo(imageButton1.snp.bottom)
        make.left.equalToSuperview()
        make.right.equalTo(self.snp.centerX)
        make.bottom.equalToSuperview()
      })
      
      imageButton4.snp.remakeConstraints({ (make) in
        make.right.equalToSuperview()
        make.top.equalTo(imageButton2.snp.bottom)
        make.bottom.equalToSuperview()
        make.left.equalTo(imageButton3.snp.right)
      })
    }
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class ImageButton: UIButton {
  
  let gradientLayer = CAGradientLayer()
  let topLineLayer = CALayer()
  let rightLineLayer = CALayer()
  let bottomLineLayer = CALayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel?.lineBreakMode = .byWordWrapping
    titleLabel?.numberOfLines = 2
    
    topLineLayer.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1).cgColor
    bottomLineLayer.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1).cgColor
    rightLineLayer.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1).cgColor
    
    gradientLayer.startPoint = CGPoint(x: 0, y: 1)
    gradientLayer.endPoint = CGPoint(x: 0, y: 0.7)
    gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    self.layer.insertSublayer(gradientLayer, below: titleLabel?.layer)
    self.layer.addSublayer(topLineLayer)
    self.layer.addSublayer(rightLineLayer)
  
    titleLabel?.font = UIFont.CheeseFontRegular(size: 13.7)
    titleEdgeInsets = UIEdgeInsetsMake(0, 10, 15, 0)
    contentHorizontalAlignment = .left
    contentVerticalAlignment = .bottom
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    UIView.performWithoutAnimation { [weak self] in
      guard let `self` = self else {return}
      self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
      self.topLineLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5)
      self.bottomLineLayer.frame = CGRect(x: 0, y: self.frame.height-0.5, width: self.frame.width, height: 0.5)
      self.rightLineLayer.frame = CGRect(x: self.frame.width-0.5, y: 0, width: 0.5, height: self.frame.height)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
