//
//  CheeseResultViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 29..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

final class CheeseResultViewCell: UICollectionReusableView {
  
  var didTap:(() -> Void)?
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.lineBreakMode = .byTruncatingTail
    label.minimumScaleFactor = 0.5
    label.textColor = .black
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  let mainView: CheeseResultSubView = {
    let view = CheeseResultSubView(frame: .zero)
    return view
  }()
  
  fileprivate lazy var anotherRankButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select_1@1x"), for: .normal)
    button.setTitle("나머지 순위보기", for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 17)
    button.setTitleColor(.cheeseColor(), for: .normal)
    button.addTarget(self, action: #selector(searchOtherRank(_:)), for: .touchUpInside)
    return button
  }()
  
  let hartButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "answer_like_nomal@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "answer_like_select@1x"), for: .selected)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setUp(){
    self.addSubview(titleLabel)
    self.addSubview(mainView)
    self.addSubview(anotherRankButton)
    self.addSubview(hartButton)
        
    titleLabel.snp.remakeConstraints { (make) in
      make.top.equalToSuperview().inset(20)
      make.left.equalToSuperview().inset(22)
      make.right.equalToSuperview().inset(80)
      make.height.lessThanOrEqualTo(40)
      make.height.greaterThanOrEqualTo(20)
    }
    titleLabel.sizeToFit()
    
    mainView.snp.remakeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(25)
      make.width.equalTo(anotherRankButton)
      make.height.lessThanOrEqualTo(300)
    }
    
    anotherRankButton.snp.remakeConstraints { (make) in
      make.top.equalTo(mainView.snp.bottom).offset(20)
      make.left.equalToSuperview().inset(22)
      make.right.equalToSuperview().inset(22)
      make.height.equalTo(50)
      make.bottom.equalToSuperview().inset(10)
    }
    
    hartButton.snp.remakeConstraints { (make) in
      make.right.equalToSuperview().inset(22)
      make.centerY.equalTo(titleLabel)
    }
  }
  
  func calculateRank(cheeseData: CheeseResultByDate.Data,topRankData: SurveyResult.Data?,totalCount: Int){
  }
  
  func setViewData(cheeseData: CheeseResultByDate.Data,topRankData: SurveyResult.Data?,totalCount: Int){
    
    self.titleLabel.text = (cheeseData.title ?? "")
    self.mainView.answerNumLabel.text = "응답수: \( topRankData?.count ?? "1")"
    self.mainView.hashTagLabel.text = "#"+(cheeseData.hash_tag ?? "").replacingOccurrences(of: " ", with: "#")
    let empathy = cheeseData.is_empathy ?? ""
    if empathy == "1"{
      self.hartButton.isSelected = true
    }
    
    guard let rankData = topRankData else {return}
    let topRankCount = Double(rankData.count ?? "") ?? 1.0
    
    
    
    let totalDoubleCount = Double(totalCount)
    let askNumber = rankData.select_ask ?? ""
    if cheeseData.is_option == "1"{
      guard Int(cheeseData.option_set_count ?? "") != nil else {return}
      if let totalCount = Double(cheeseData.option_set_count ?? ""){
        self.mainView.answerPercentLabel.text = "응답율:\(((topRankCount/totalCount)*100).roundToPlaces(places: 2))%"
      }
    } else {
      self.mainView.answerPercentLabel.text = "응답율:\(((topRankCount/totalDoubleCount)*100).roundToPlaces(places: 2))%"
    }
    switch askNumber {
    case "1":
      self.mainView.titleLabel.text = "1위, " + (cheeseData.ask1 ?? "")
      guard let imgurl = cheeseData.ask1_img_url else { return }
      let url = URL(string: imgurl.getUrlWithEncoding())
      self.mainView.kf.setImage(with: url)
    case "2":
      self.mainView.titleLabel.text = "1위, " + (cheeseData.ask2 ?? "")
      guard let imgurl = cheeseData.ask2_img_url else { return }
      let url = URL(string: imgurl.getUrlWithEncoding())
      self.mainView.kf.setImage(with: url)
    case "3":
      self.mainView.titleLabel.text = "1위, " + (cheeseData.ask3 ?? "")
      guard let imgurl = cheeseData.ask3_img_url else { return }
      let url = URL(string: imgurl.getUrlWithEncoding())
      self.mainView.kf.setImage(with: url)
    case "4":
      self.mainView.titleLabel.text = "1위, " + (cheeseData.ask4 ?? "")
      guard let imgurl = cheeseData.ask4_img_url else { return }
      let url = URL(string: imgurl.getUrlWithEncoding())
      self.mainView.kf.setImage(with: url)
    default:
      break
    }
  }
  
  @objc fileprivate dynamic func searchOtherRank(_ sender: UIButton){
    guard let tap = self.didTap else { return }
    tap()
  }
}


class CheeseResultSubView: UIImageView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.numberOfLines = 1
    if UIDevice.current.model == "iPad"{
      label.font = UIFont.CheeseFontMedium(size: 10)
    }else{
      label.font = UIFont.CheeseFontMedium(size: 16)
    }
    return label
  }()
  
  fileprivate let personIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_person@1x").withRenderingMode(.alwaysTemplate))
    img.tintColor = .white
    return img
  }()
  
  fileprivate let graphIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_graph@1x").withRenderingMode(.alwaysTemplate))
    img.tintColor = .white
    return img
  }()
  
  fileprivate let tagIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_tag@1x").withRenderingMode(.alwaysTemplate))
    img.tintColor = .white
    return img
  }()
  
  fileprivate let divideLine: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  fileprivate let gradationView: UIView = {
    let view = UIView()
    return view
  }()
  
  let answerNumLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.font = UIFont.CheeseFontMedium(size: 14)
    return label
  }()
  
  let answerPercentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.textColor = .white
    return label
  }()
  
  let hashTagLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .lightGray
    self.addSubview(gradationView)
    self.addSubview(personIcon)
    self.addSubview(graphIcon)
    self.addSubview(tagIcon)
    self.addSubview(divideLine)
    self.addSubview(titleLabel)
    self.addSubview(answerNumLabel)
    self.addSubview(answerPercentLabel)
    self.addSubview(hashTagLabel)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(self.snp.centerY)
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
    }
    
    divideLine.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
      make.height.equalTo(1)
    }
    
    personIcon.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin)
      make.top.equalTo(divideLine.snp.bottom).offset(10)
      make.height.equalTo(10)
      make.width.equalTo(personIcon.snp.height)
    }
    
    answerNumLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(personIcon.snp.right).offset(8)
      make.right.equalTo(graphIcon.snp.left).offset(-5)
      make.height.equalTo(15)
      make.centerY.equalTo(self.personIcon)
    }
    
    graphIcon.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.centerX)
      make.centerY.equalTo(answerNumLabel)
      make.height.equalTo(personIcon)
      make.width.equalTo(graphIcon.snp.height)
    }
    
    answerPercentLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(self.graphIcon.snp.right).offset(8)
      make.right.equalToSuperview()
      make.height.equalTo(answerNumLabel)
      make.centerY.equalTo(answerNumLabel)
    }
    
    tagIcon.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin)
      make.height.equalTo(personIcon)
      make.width.equalTo(personIcon)
      make.top.equalTo(personIcon.snp.bottom).offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    
    hashTagLabel.snp.remakeConstraints { (make) in
      make.left.equalTo(tagIcon.snp.right).offset(8)
      make.right.equalTo(self.snp.rightMargin)
      make.bottom.equalToSuperview()
      make.top.equalTo(answerNumLabel.snp.bottom)
    }
    
    gradationView.snp.remakeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }
    
    let layer = CAGradientLayer()
    layer.frame = gradationView.bounds
    layer.startPoint = CGPoint(x: 0, y: 1)
    layer.endPoint = CGPoint(x: 0, y: 0)
    layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    gradationView.layer.addSublayer(layer)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
