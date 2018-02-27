////
////  SaleCheeseViewCell.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 4. 19..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//import Spring
//
//class SaleGoldViewCell: UICollectionViewCell, UITextFieldDelegate{
//  
//  static let ID = "SaleGoldViewCell"
//  
//  var currentGoldViewController: CurrentGoldViewController?{
//    didSet{
//      depositorTextField.text = currentGoldViewController?.goldReturnData.name
//      accountNumberTextField.text = currentGoldViewController?.goldReturnData.account_number
//      switch currentGoldViewController?.goldReturnData.cash ?? ""{
//      case "10000":
//        moneyButtons[0].isSelected = true
//      case "20000":
//        moneyButtons[1].isSelected = true
//      case "30000":
//        moneyButtons[2].isSelected = true
//      case "40000":
//        moneyButtons[3].isSelected = true
//      case "50000":
//        moneyButtons[4].isSelected = true
//      default:
//        moneyButtons.forEach({ (button) in
//          button.isSelected = false
//        })
//      }
//    }
//  }
//  
//  let salesNumLabel: UILabel = UILabel()
//  let accountNumberLabel: UILabel = UILabel()
//  let depositorLabel: UILabel = UILabel()
//  let bankNameLabel:UILabel = UILabel()
//  let refundAccountNumberLabel: UILabel = UILabel()
//  
//  let scrollView: UIScrollView = {
//    let scrollView = UIScrollView()
//    scrollView.alwaysBounceVertical = true
//    return scrollView
//  }()
//  
//  
//  let depositorTextField: UITextField = {
//    let textField = UITextField()
//    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//    textField.leftViewMode = .always
//    textField.layer.borderWidth = 0.5
//    textField.textAlignment = .center
//    textField.layer.borderColor = UIColor.lightGray.cgColor
//    textField.tag = 0
//    return textField
//  }()
//  
//  lazy var selectBankButton: UIButton = {
//    let button = UIButton()
//    button.setTitle("은행을 선택하세요", for: .normal)
//    button.setTitleColor(.black, for: .normal)
//    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 17)
//    button.semanticContentAttribute = .forceRightToLeft
//    button.setImage(#imageLiteral(resourceName: "arrow_drop@1x"), for: .normal)
//    button.layer.borderWidth = 0.5
//    button.layer.borderColor = UIColor.lightGray.cgColor
//    return button
//  }()
//  
//  let accountNumberTextField: UITextField = {
//    let textField = UITextField()
//    textField.textAlignment = .center
//    textField.layer.borderWidth = 0.5
//    textField.layer.borderColor = UIColor.lightGray.cgColor
//    textField.textAlignment = .center
//    textField.keyboardType = .numbersAndPunctuation
//    textField.tag = 1
//    return textField
//  }()
//  
//  lazy var moneyButtons: [UIButton] = {
//    var buttons = [UIButton]()
//    for num in 1...5{
//      let button = UIButton()
//      button.setTitle("\(num)만원", for: .normal)
//      button.setTitleColor(.black, for: .normal)
//      button.setTitleColor(.white, for: .selected)
//      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
//      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
//      button.addTarget(self, action: #selector(moneyButtonAction(_:)), for: .touchUpInside)
//      button.tag = num*10000
//      buttons.append(button)
//    }
//    let button = UIButton()
//    button.setTitle("최대", for: .normal)
//    button.layer.borderWidth = 1
//    button.layer.borderColor = UIColor.blue.cgColor
//    buttons.append(button)
//    return buttons
//  }()
//  
//  let salesButton: SpringButton = {
//    let button = SpringButton()
//    button.setTitle("골드 환급 요청", for: .normal)
//    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select_1@1x"), for: .normal)
//    button.semanticContentAttribute = .forceRightToLeft
//    return button
//  }()
//  
//  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    if UIDevice.current.model == "iPad"{
//      scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height + 150)
//    }else {
//      scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//    }
//  }
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    
//    setUpLabel()
//    
//    self.contentView.addSubview(scrollView)
//    scrollView.addSubview(salesNumLabel)
//    scrollView.addSubview(selectBankButton)
//    scrollView.addSubview(accountNumberLabel)
//    scrollView.addSubview(depositorLabel)
//    scrollView.addSubview(bankNameLabel)
//    scrollView.addSubview(refundAccountNumberLabel)
//    scrollView.addSubview(depositorTextField)
//    scrollView.addSubview(accountNumberTextField)
//    scrollView.addSubview(salesButton)
//    
//    depositorTextField.delegate = self
//    accountNumberTextField.delegate = self
//    
//    moneyButtons.forEach {
//      self.scrollView.addSubview($0)
//    }
//    
//    addConstraint()
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.endEditing(true)
//    return true
//  }
//  
//  @objc func moneyButtonAction(_ sender: UIButton){
//    sender.isSelected = sender.isSelected ? false : true
//    moneyButtons.forEach { (button) in
//      if button.tag != sender.tag {
//        button.isSelected = false
//      }
//    }
//    
//    guard let homeViewController = currentGoldViewController else { return }
//    homeViewController.goldReturnData.cash = "\(sender.tag)"
//  }
//  
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    guard let homeViewController = currentGoldViewController else {return}
//    if textField.tag == 0{
//      homeViewController.goldReturnData.name = textField.text ?? ""
//    } else {
//      homeViewController.goldReturnData.account_number = textField.text ?? ""
//    }
//  }
//  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if self.depositorTextField.isFirstResponder{
//      self.depositorTextField.endEditing(true)
//    } else {
//      self.accountNumberTextField.endEditing(true)
//    }
//  }
//  
//  func setUpLabel(){
//    salesNumLabel.text = "골드 환급 요청액"
//    salesNumLabel.sizeToFit()
//    salesNumLabel.font = UIFont.CheeseFontMedium(size: 15)
//    salesNumLabel.textColor = .black
//    
//    accountNumberLabel.text = "계좌번호"
//    accountNumberLabel.sizeToFit()
//    accountNumberLabel.font = UIFont.CheeseFontMedium(size: 15)
//    accountNumberLabel.textColor = .black
//    
//    depositorLabel.text = "예금주"
//    depositorLabel.sizeToFit()
//    depositorLabel.font = UIFont.CheeseFontMedium(size: 15)
//    depositorLabel.textColor = .black
//    
//    bankNameLabel.text = "입금은행"
//    bankNameLabel.sizeToFit()
//    bankNameLabel.font = UIFont.CheeseFontMedium(size: 15)
//    bankNameLabel.textColor = .black
//    
//    refundAccountNumberLabel.text = "계좌번호"
//    refundAccountNumberLabel.sizeToFit()
//    refundAccountNumberLabel.font = UIFont.CheeseFontMedium(size: 15)
//    refundAccountNumberLabel.textColor = .black
//  }
//  
//  func addConstraint(){
//    let width = UIScreen.main.bounds.width
//    
//    scrollView.snp.makeConstraints { (make) in
//      make.edges.equalToSuperview()
//    }
//    
//    salesNumLabel.snp.makeConstraints { (make) in
//      make.top.equalToSuperview().offset(10)
//      make.left.equalToSuperview().inset(25)
//    }
//    
//    moneyButtons[0].snp.makeConstraints { (make) in
//      make.top.equalTo(salesNumLabel.snp.bottom).offset(10)
//      make.left.equalToSuperview().inset(25)
//      make.height.equalTo(40)
//      make.width.equalTo(width/3.5)
//    }
//    
//    moneyButtons[1].snp.makeConstraints { (make) in
//      make.top.equalTo(moneyButtons[0].snp.top)
//      make.centerX.equalToSuperview()
//      make.height.equalTo(moneyButtons[0])
//      make.width.equalTo(moneyButtons[0])
//    }
//    
//    moneyButtons[2].snp.makeConstraints { (make) in
//      make.top.equalTo(moneyButtons[0])
//      make.right.equalTo(self.snp.right).inset(25)
//      make.height.equalTo(moneyButtons[0])
//      make.width.equalTo(moneyButtons[0])
//    }
//    
//    moneyButtons[3].snp.makeConstraints { (make) in
//      make.top.equalTo(moneyButtons[0].snp.bottom).offset(10)
//      make.left.equalTo(moneyButtons[0])
//      make.height.equalTo(moneyButtons[0])
//      make.width.equalTo(moneyButtons[0])
//    }
//    
//    moneyButtons[4].snp.makeConstraints { (make) in
//      make.top.equalTo(moneyButtons[3])
//      make.centerX.equalToSuperview()
//      make.height.equalTo(moneyButtons[0])
//      make.width.equalTo(moneyButtons[0])
//    }
//    
//    refundAccountNumberLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(moneyButtons[3].snp.bottom).offset(20)
//      make.left.equalToSuperview().inset(25)
//    }
//    
//    depositorLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(refundAccountNumberLabel.snp.bottom).offset(20)
//      make.left.equalTo(refundAccountNumberLabel)
//    }
//    
//    bankNameLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(depositorLabel.snp.bottom).offset(20)
//      make.left.equalTo(refundAccountNumberLabel)
//    }
//    
//    
//    accountNumberLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(bankNameLabel.snp.bottom).offset(20)
//      make.left.equalTo(bankNameLabel)
//    }
//    
//    depositorTextField.snp.makeConstraints { (make) in
//      make.centerY.equalTo(depositorLabel)
//      make.right.equalTo(self.snp.right).inset(25)
//      make.width.equalTo(width/1.5)
//      make.height.equalTo(40)
//    }
//    
//    selectBankButton.snp.makeConstraints { (make) in
//      make.centerY.equalTo(bankNameLabel)
//      make.right.equalTo(depositorTextField)
//      make.left.equalTo(depositorTextField)
//      make.height.equalTo(40)
//    }
//    
//    accountNumberTextField.snp.makeConstraints { (make) in
//      make.centerY.equalTo(accountNumberLabel)
//      make.right.equalTo(self.snp.right).inset(25)
//      make.width.equalTo(width/1.5)
//      make.height.equalTo(40)
//    }
//    
//    salesButton.snp.makeConstraints { (make) in
//      make.left.equalToSuperview().inset(25)
//      make.right.equalToSuperview().inset(25)
//      make.bottom.equalToSuperview().inset(44)
//      make.top.equalTo(accountNumberTextField.snp.bottom).offset(10)
//    }
//  }
//  
//}

