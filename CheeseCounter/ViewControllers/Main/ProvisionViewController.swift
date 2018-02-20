//
//  ProvisionViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

enum Agree: Int {
  case agree
  case disagree
}

class ProvisionViewController: BaseSetupViewController {
  
  var serviceAgree = false
  var provisionAgree = false
  let provisionLabel: UILabel = {
    let label = UILabel()
    label.text = "서비스 이용약관"
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()
  
  let detailProvisionTextView: UITextView = {
    
    let attributeText = NSMutableAttributedString(string: "치즈카운터 서비스 이용약관에 대한 동의\n\n"
      ,attributes: [NSAttributedStringKey.foregroundColor:UIColor.black
        ,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
    let provisionData = Bundle.provisionFromFile(name: "provision")
    let provisionString = String.init(data: provisionData, encoding: .utf8)
    attributeText.append(NSAttributedString(string: provisionString ?? ""
      ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)]))
    let dpt = UITextView()
    dpt.backgroundColor = .clear
    dpt.attributedText = attributeText
    dpt.layer.borderWidth = 0.5
    dpt.layer.borderColor = UIColor.lightGray.cgColor
    dpt.isEditable = false
    dpt.isSelectable = false
    return dpt
  }()
  
  lazy var provisionButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "checkbox_leave_off@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "checkbox_leave_on@1x"), for: .selected)
    button.setTitle("  동의합니다", for: .normal)
    button.setTitleColor(.gray, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.sizeToFit()
    button.tag = 0
    button.addTarget(self, action: #selector(provisionButtonClick(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var privateProvisionButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "checkbox_leave_off@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "checkbox_leave_on@1x"), for: .selected)
    button.setTitle("  동의합니다.", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(provisionButtonClick(_:)), for: .touchUpInside)
    button.sizeToFit()
    button.tag = 1
    return button
  }()
  
  let privateProvisionTextView: UITextView = {
    let attributeText = NSMutableAttributedString(string: "치즈카운터 서비스 개인정보 취급방침에 대한 동의\n\n"
      ,attributes: [NSAttributedStringKey.foregroundColor:UIColor.black
        ,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
    let provisionData = Bundle.provisionFromFile(name: "privacy")
    let provisionString = String.init(data: provisionData, encoding: .utf8)
    attributeText.append(NSAttributedString(string: provisionString ?? "",attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)]))
    let textView = UITextView()
    textView.backgroundColor = .clear
    textView.attributedText = attributeText
    textView.isEditable = false
    textView.isSelectable = false
    textView.layer.borderWidth = 0.5
    textView.layer.borderColor = UIColor.lightGray.cgColor
    return textView
  }()
  
  lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select_1@1x"), for: .normal)
    button.setTitleColor(.cheeseColor(), for: .normal)
    button.setTitle("시작하기", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.addTarget(self, action: #selector(startAction), for: .touchUpInside)
    return button
  }()
  
  override func setup(){
    self.view.backgroundColor = UIColor.cheeseColor()
    self.titleLabel.text = "이용약관 및 개인정보 취급방침"
    provisionLabel.setBottomBorderColor(color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), height: 2)
    self.view.addSubview(provisionLabel)
    self.view.addSubview(provisionButton)
    self.view.addSubview(detailProvisionTextView)
    self.view.addSubview(privateProvisionButton)
    self.view.addSubview(privateProvisionTextView)
    self.view.addSubview(nextButton)
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(empty))
    swipeGesture.delegate = self
    self.detailProvisionTextView.addGestureRecognizer(swipeGesture)
    self.privateProvisionTextView.addGestureRecognizer(swipeGesture)
    addConstraint()
  }
  
  @objc func empty(){}
  
  func addConstraint(){
    
    provisionLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    detailProvisionTextView.snp.makeConstraints { (make) in
      make.top.equalTo(provisionLabel.snp.bottom)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.lessThanOrEqualTo(155)
    }
    
    provisionButton.snp.makeConstraints { (make) in
      make.top.equalTo(detailProvisionTextView.snp.bottom)
      make.left.equalTo(detailProvisionTextView)
      make.height.equalTo(50)
    }
    
    privateProvisionTextView.snp.makeConstraints { (make) in
      make.top.equalTo(provisionButton.snp.bottom)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(detailProvisionTextView)
    }
    
    privateProvisionButton.snp.makeConstraints { (make) in
      make.top.equalTo(privateProvisionTextView.snp.bottom)
      make.left.equalTo(provisionButton)
      make.height.equalTo(50)
    }
    
    nextButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.bottom.equalToSuperview().inset(22.5)
      make.right.equalToSuperview().inset(25)
      make.top.equalTo(privateProvisionButton.snp.bottom).offset(30)
    }
  }
  
  @objc func provisionButtonClick(_ button: UIButton){
    button.isSelected = button.isSelected ? false : true
    switch button.tag {
    case 0:
      if button.isSelected{
        serviceAgree = true
      } else {
        serviceAgree = false
      }
    case 1:
      if button.isSelected{
        provisionAgree = true
      } else {
        provisionAgree = false
      }
    default:
      break
    }
    
    if serviceAgree && provisionAgree {
      self.isdisableScroll = false
      self.userSetupViewController?.signUp.provisionComple = true
    } else {
      self.isdisableScroll = true
      self.userSetupViewController?.signUp.provisionComple = false
    }
  }
  
  @objc fileprivate dynamic func startAction(){
    
    if !isdisableScroll {
      self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 1)
    } else {
      swipeAction()
    }
  }
  
  override func swipeAction(){
    let alertViewController = UIAlertController(title: "약관동의",
                                                message: "서비스 이용약관과\n개인정보 취급방침에 동의하시면\n서비스 이용이 가능합니다.",
                                                preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    
    alertViewController.addAction(alertAction)
    if serviceAgree && provisionAgree{
    }else {
      self.present(alertViewController, animated: true, completion: nil)
    }
  }
}



