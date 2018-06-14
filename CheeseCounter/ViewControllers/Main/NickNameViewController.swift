//
//  NickNameViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class NickNameViewController: BaseSetupViewController{
  
  let nickNameConfirmLabel: UILabel = {
    let label = UILabel()
    label.text = "회원님의 닉네임을 확인해주세요"
    label.font = UIFont.CheeseFontBold(size: 20)
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()
  
  let mainImgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "bg_illust_nickname@1x"))
    img.contentMode = .scaleAspectFit
    return img
  }()
  
  lazy var nickNameTextField : UITextField = {
    let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    let textField = UITextField()
    textField.leftViewMode = .always
    textField.leftView = spacerView
    textField.textAlignment = .center
    textField.backgroundColor = .white
    textField.placeholder = "입력해주세요"
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    textField.delegate = self
    return textField
  }()
  
  //TODO: 중복확인전 한글,숫자,영문 12자까지 입력한부분 확인 후 중복확인 필요
  lazy var duplicateButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("중복확인", for: .normal)
    bt.setTitle("중복확인 완료", for: .selected)
    bt.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
    bt.setTitleColor(.white, for: .normal)
    bt.addTarget(self, action: #selector(self.confirmDuplicated(_:)), for: .touchUpInside)
    return bt
  }()
  
  let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = "✧ 닉네임은 최대 한글, 숫자, 영문 12자까지 입력할 수 있습니다."
    label.font = UIFont.systemFont(ofSize: 10)
    label.textAlignment = .center
    return label
  }()
  
  lazy var deleteButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    button.setImage(#imageLiteral(resourceName: "input_delete@1x"), for: .normal)
    button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    return button
  }()
  
  override func setup()
  {
    self.view.backgroundColor = .cheeseColor()
    self.view.addSubview(nickNameTextField)
    self.view.addSubview(duplicateButton)
    self.view.addSubview(subtitleLabel)
    self.view.addSubview(mainImgView)
    self.view.addSubview(nickNameConfirmLabel)
    nickNameTextField.rightView = deleteButton
    nickNameTextField.rightViewMode = .whileEditing
    self.titleLabel.text = "회원정보 추가"
    
    
    nickNameConfirmLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(100)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalTo(mainImgView.snp.top).offset(10)
    }
    
    mainImgView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(nickNameConfirmLabel.snp.bottom).offset(40).priority(899)
      make.height.lessThanOrEqualTo(200)
      make.width.equalTo(mainImgView.snp.height)
    }
    
    nickNameTextField.snp.makeConstraints { (make) in
      make.top.equalTo(mainImgView.snp.bottom).offset(50).priority(900)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.greaterThanOrEqualTo(20)
      make.height.lessThanOrEqualTo(50)
    }
    
    duplicateButton.snp.makeConstraints { (make) in
      make.top.equalTo(nickNameTextField.snp.bottom).offset(10)
      make.left.equalTo(nickNameTextField)
      make.right.equalTo(nickNameTextField)
      make.height.equalTo(nickNameTextField)
    }
    
    subtitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(duplicateButton.snp.bottom).offset(20)
      make.left.equalToSuperview().inset(50)
      make.right.equalToSuperview().inset(50)
      make.bottom.equalToSuperview().inset(100)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    if self.userSetupViewController?.signUp.provisionComple == nil ||
      self.userSetupViewController?.signUp.provisionComple == false{
      AlertView(title: "알림", message: "약관동의를 해주세요", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: { (_) in
          self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 0)
        })
      .show()
    }
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillHide(_ sender: Notification) {
    if let _ = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y != 0{
        self.view.frame.origin.y = 0
      }
    }
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0{
        self.view.frame.origin.y -= keyboardSize.height
      }
    }
  }
  
  
  @objc fileprivate dynamic func confirmDuplicated(_ sender: UIButton){
    self.nickNameTextField.endEditing(true)
    let textCount = nickNameTextField.text?.count
    if textCount! > 1 && textCount! < 12{
      let nickname = self.nickNameTextField.text
      UserService.check(nickname: nickname!){ [weak self] response in
        if let `self` = self {
          switch response.result {
          case .success(let value):
            guard let count = value.count else {return}
            if count == 0 {
              self.alertAction(isExist: true,sender: sender)
            } else {
              self.alertAction(isExist: false,sender: sender)
            }
          case .failure(let error):
            log.error(error.localizedDescription)
          }
        }
      }
    } else {
      let alertController = UIAlertController(title: "알림", message: "닉네임은 12자까지 \n입력할 수 있습니다.", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  fileprivate func alertAction(isExist: Bool,sender: UIButton){
    
    let trueMessage = "사용 가능한\n닉네임입니다.\n사용하시겠습니까?"
    let falseMessage = "이미 사용중 이거나 불가능합니다."
    
    if isExist {
      let alertViewController = UIAlertController(title: "",
                                                  message: trueMessage,
                                                  preferredStyle: UIAlertControllerStyle.alert)
      let trueAction = UIAlertAction(title: "예", style: .default, handler: {[weak self] (_) in
        guard let `self` = self else {return}
        sender.isSelected = true
        self.userSetupViewController?.signUp.nickName = self.nickNameTextField.text
        self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 2)
        self.isdisableScroll = false
      })
      let falseAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
      alertViewController.addAction(trueAction)
      alertViewController.addAction(falseAction)
      self.present(alertViewController, animated: true, completion: nil)
    } else {
      let alertViewController = UIAlertController(title: "",
                                                  message: falseMessage,
                                                  preferredStyle: UIAlertControllerStyle.alert)
      let action = UIAlertAction(title: "에러", style: .cancel, handler: nil)
      alertViewController.addAction(action)
      self.present(alertViewController, animated: true, completion: nil)
    }
  }
  
  @objc fileprivate dynamic func deleteAction(){
    nickNameTextField.text = ""
  }
  
  override func swipeAction(){
    if isdisableScroll {
      
      let alertController = UIAlertController(title: "알림", message: "중복확인을 눌러주세요", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  //MARK: - Keyboard Event
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

extension NickNameViewController: UITextFieldDelegate
{
  func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField.text?.count ?? 0) <= 1 {
      self.duplicateButton.isSelected = false
      isdisableScroll = true
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
  
}


