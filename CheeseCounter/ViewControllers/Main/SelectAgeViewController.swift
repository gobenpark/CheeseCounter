//
//  SelectAgeViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 12..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectAgeViewController: BaseSetupViewController{
  
  let mainLabel: UILabel = {
    let label = UILabel()
    label.text = "회원님의 나이를 입력해주세요."
    label.font = UIFont.boldSystemFont(ofSize: 15)
    label.sizeToFit()
    return label
  }()
  
  lazy var ageTextField: UITextField = {
    let textField = UITextField()
    textField.textAlignment = .center
    textField.returnKeyType = .done
    textField.keyboardType = .numberPad
    textField.backgroundColor = .white
    textField.layer.borderWidth = 0.5
    textField.font = UIFont.CheeseFontBold(size: 30)
    textField.delegate = self
    return textField
  }()
  
  override func setup() {
    self.view.backgroundColor = .cheeseColor()
    self.view.addSubview(mainLabel)
    self.view.addSubview(ageTextField)
    
    isdisableScroll = true
    mainLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(68)
      make.centerX.equalToSuperview()
    }
    
    ageTextField.snp.makeConstraints { (make) in
      make.top.equalTo(mainLabel.snp.bottom).offset(50)
      make.centerX.equalToSuperview()
      make.height.equalTo(150)
      make.width.equalTo(150)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let age = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: ageTextField.frame.height))
    age.text = "세"
    ageTextField.rightView = age
    ageTextField.rightViewMode = .unlessEditing
    
    if self.userSetupViewController?.signUp.gender == nil{
      AlertView(title: "알림", message: "성별을 입력해 주세요", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: { (_) in
          self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 2)
        })
        .show()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.ageTextField.endEditing(true)
  }
  override func swipeAction(){
    if isdisableScroll {
      let alertController = UIAlertController(title: "알림", message: "나이를 입력해 주세요", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
}

extension SelectAgeViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {return}
    if text.characters.count != 0{
      if (Int(text) ?? 0) < 14 {
        
        AlertView(title: "알림", message: "14세 미만은\n사용할 수 없습니다.", preferredStyle: .alert)
          .addChildAction(title: "확인", style: .default, handeler: { [weak self] (_) in
            self?.isdisableScroll = true
            textField.text = ""
          }).show()
        return
      }else if (Int(text) ?? 0) > 100{
        AlertView(title: "알림", message: "정확한 나이를 입력해주세요.", preferredStyle: .alert)
          .addChildAction(title: "확인", style: .default, handeler: { [weak self] (_) in
            self?.isdisableScroll = true
            textField.text = ""
          }).show()
        return
      }
      isdisableScroll = false
      self.userSetupViewController?.signUp.age = textField.text
      self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 4)
    } else {
      isdisableScroll = true
      textField.text = ""
    }
  }
}


