//
//  PayForGoldViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class PayForGoldViewCell: UICollectionViewCell
{
  static let ID = "PayForGoldViewCell"
  
  private var totalCount = 0
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  fileprivate let purchaseLabel: UILabel = {
    let label = UILabel()
    label.text = "구매 골드"
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 15)
    return label
  }()
  
  fileprivate let paymentLabel: UILabel = {
    let label = UILabel()
    label.text = "결제 금액"
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 15)
    return label
  }()
  
  fileprivate lazy var resetButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    button.setImage(#imageLiteral(resourceName: "input_delete@1x").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(deleteTextViewAction), for: .touchUpInside)
    return button
  }()
  
  fileprivate lazy var goldLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.layer.borderWidth = 0.5
    label.layer.borderColor = UIColor.lightGray.cgColor
    return label
  }()
  
  fileprivate lazy var goldButtons: [UIButton] = {
    var buttons = [UIButton]()
    for i in 0...3 {
      let button = UIButton()
      button.tag = i
      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
      button.setTitleColor(.black, for: .normal)
      button.setTitleColor(.white, for: .selected)
      button.addTarget(self, action: #selector(touchGoldButton(_:)), for: .touchUpInside)
      buttons.append(button)
    }
    return buttons
  }()
  
  fileprivate var sumPaymentLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.layer.cornerRadius = 10
    label.layer.borderWidth = 1
    label.layer.borderColor = UIColor.white.cgColor
    label.layer.masksToBounds = true
    label.textAlignment = .right
    label.font = UIFont.CheeseFontBold(size: 18)
    return label
  }()
  
  lazy var payButton: UIButton = {
    let button = UIButton()
    button.setTitle("결제하기", for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select_1@1x"), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(payButtonAction), for: .touchUpInside)
    return button
  }()
  
  fileprivate let divideLine: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.goldLabel.endEditing(true)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if UIDevice.current.model == "iPad"{
      scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height + 150)
    }else {
      scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
    }
  }
  
  func setUp(){
    
    self.contentView.addSubview(scrollView)
    
    scrollView.addSubview(purchaseLabel)
    scrollView.addSubview(paymentLabel)
    scrollView.addSubview(goldLabel)
    scrollView.addSubview(sumPaymentLabel)
    scrollView.addSubview(payButton)
    scrollView.addSubview(divideLine)
    scrollView.addSubview(resetButton)
    for button in goldButtons {
      self.addSubview(button)
    }
    
    
    scrollView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    purchaseLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(40)
      make.left.equalToSuperview().inset(25)
      make.width.equalTo(100)
    }
    
    goldLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(purchaseLabel)
      make.left.equalTo(self.purchaseLabel.snp.right)
      make.right.equalTo(self.snp.rightMargin).inset(40)
      make.height.equalTo(40)
    }
    
    resetButton.snp.makeConstraints { (make) in
      make.left.equalTo(goldLabel.snp.right)
      make.top.equalTo(goldLabel)
      make.bottom.equalTo(goldLabel)
      make.width.equalTo(goldLabel.snp.height)
    }
    
    goldButtons[0].snp.makeConstraints { (make) in
      make.top.equalTo(goldLabel.snp.bottom).offset(30)
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.snp.centerX).inset(-5)
      make.height.equalTo(50)
    }
    
    goldButtons[1].snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.centerX).inset(5)
      make.centerY.equalTo(goldButtons[0])
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(goldButtons[0])
    }
    
    goldButtons[2].snp.makeConstraints { (make) in
      make.left.equalTo(goldButtons[0])
      make.right.equalTo(goldButtons[0])
      make.top.equalTo(goldButtons[0].snp.bottom).offset(10)
      make.height.equalTo(goldButtons[0])
    }
    
    goldButtons[3].snp.makeConstraints { (make) in
      make.left.equalTo(goldButtons[1])
      make.centerY.equalTo(goldButtons[2])
      make.right.equalTo(goldButtons[1])
      make.height.equalTo(goldButtons[0])
    }
    
    paymentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(goldButtons[3].snp.bottom).offset(50)
      make.left.equalTo(purchaseLabel)
      make.width.equalTo(100)
    }
    
    sumPaymentLabel.snp.makeConstraints { (make) in
      make.left.equalTo(self.paymentLabel.snp.right).offset(20)
      make.centerY.equalTo(paymentLabel)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    divideLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.top.equalTo(paymentLabel.snp.bottom).offset(16)
      make.height.equalTo(0.5)
    }
    
    payButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalToSuperview().offset(24)
      make.top.equalTo(divideLine.snp.bottom).offset(15)
    }
    
    setButtonText()
  }
  
  func deleteTextViewAction(_ sender: UIButton){
    goldLabel.text = ""
    totalCount = 0
    sumPaymentLabel.text = ""
    goldButtons.forEach { (button) in
      button.isSelected = false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField.text?.characters.count ?? 0) > 0 {
      totalCount += Int(textField.text ?? "") ?? 0
      sumPaymentLabel.text = (textField.text ?? "")+"골드"
    } else {
      totalCount = 0
    }
  }
  
  func doneClick() {
    goldLabel.endEditing(true)
  }
  
  func setButtonText(){
    goldButtons[0].setTitle("1백골드", for: .normal)
    goldButtons[1].setTitle("1천골드", for: .normal)
    goldButtons[2].setTitle("1만골드", for: .normal)
    goldButtons[3].setTitle("10만골드", for: .normal)
  }
  
  fileprivate dynamic func touchGoldButton(_ sender: UIButton){
    goldButtons.forEach { (button) in
      button.isSelected = false
    }
    sender.isSelected = true
    
    switch sender.tag {
    //1백
    case 0:
      totalCount += 100
      self.goldLabel.text = totalCount.stringFormattedWithSeparator()+"골드"
      self.sumPaymentLabel.text = "\(Int(Double(totalCount)*1.3).stringFormattedWithSeparator())원"
    //1천
    case 1:
      totalCount += 1000
      self.goldLabel.text = totalCount.stringFormattedWithSeparator()+"골드"
      self.sumPaymentLabel.text = "\(Int(Double(totalCount)*1.3).stringFormattedWithSeparator())원"
    //1만
    case 2:
      totalCount += 10000
      self.goldLabel.text = totalCount.stringFormattedWithSeparator()+"골드"
      self.sumPaymentLabel.text = "\(Int(Double(totalCount)*1.3).stringFormattedWithSeparator())원"
    //10만
    case 3:
      totalCount += 100000
      self.goldLabel.text = totalCount.stringFormattedWithSeparator()+"골드"
      self.sumPaymentLabel.text = "\(Int(Double(totalCount)*1.3).stringFormattedWithSeparator())원"
    default:
      break
    }
    
  }
  
  func payButtonAction(_ sender: UIButton){
    if totalCount == 0 {
      let alertVC = UIAlertController(title: "알림", message: "금액을 입력해주세요", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      AppDelegate.instance?.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
      return
    }
    
    if totalCount > 1000000{
      AlertView(title: "알림", message: "일일 최대 골드구매액은 100만원 입니다.", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: nil)
        .show()
      return
    }
    
    let paymentVC = PaymentViewController()
    guard let token = UserService.mainParameter["access_token"] as? String else {return}
    paymentVC.paymentData = PayData(pay_method: "card",
                                    amount: "\(Int(Double(totalCount) * 1.3))",
      gold: "\(totalCount)",
      access_token: token )
    AppDelegate.instance?.window?.rootViewController?.present(UINavigationController(rootViewController: paymentVC)
      , animated: true
      , completion: nil)
    
  }
  
}

