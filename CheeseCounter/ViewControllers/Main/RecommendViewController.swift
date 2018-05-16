//
//  RecommendViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 5. 3..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class RecommendViewController: BaseSetupViewController {
  
  private let disposeBag = DisposeBag()
  let recommenderNicknameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontBold(size: 12)
    label.text = "mynameis20 님께"
    label.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()
  
  let recommendLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontBold(size: 18)
    label.numberOfLines = 0
    label.text = "500치즈를 지급해드립니다!"
    label.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()
  
  let recommendLabel2: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 14)
    label.textColor = UIColor.rgb(red: 85, green: 85, blue: 85)
    label.numberOfLines = 2
    label.text = "치즈카운터를 추천해주신 분의\n코드를 입력해주세요."
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()
  
  let mainImgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "imgInviteCode"))
    img.contentMode = .scaleAspectFit
    return img
  }()
  
  lazy var recommendCodeTextField : UITextField = {
    let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    let textField = UITextField()
    textField.leftViewMode = .always
    textField.leftView = spacerView
    textField.textAlignment = .center
    textField.backgroundColor = .white
    textField.placeholder = "ex)123456789"
    textField.keyboardType = .decimalPad
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    textField.delegate = self
    return textField
  }()
  
  lazy var deleteButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    button.setImage(#imageLiteral(resourceName: "input_delete@1x"), for: .normal)
    button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    return button
  }()
  
  lazy var confirmButton : UIButton = {
    let btn = UIButton()
    btn.setTitle("확인", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
    btn.setTitleColor(.white, for: .normal)
    btn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    return btn
  }()
  
  lazy var skipButton : UIButton = {
    let btn = UIButton()
    btn.setTitle("건너뛰기", for: .normal)
    btn.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.7176470588, blue: 0.7411764706, alpha: 1)
    btn.setTitleColor(.white, for: .normal)
    btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    return btn
  }()
  
  override func setup() {
    self.titleLabel.text = "회원정보 추가"
    
    view.addSubview(recommenderNicknameLabel)
    view.addSubview(mainImgView)
    view.addSubview(recommendLabel)
    view.addSubview(recommendLabel2)
    view.addSubview(recommendCodeTextField)
    view.addSubview(confirmButton)
    view.addSubview(skipButton)
    recommendCodeTextField.rightView = deleteButton
    recommendCodeTextField.rightViewMode = .whileEditing
    
    recommenderNicknameLabel.snp.makeConstraints{ (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
    }
    
    mainImgView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.height.lessThanOrEqualTo(200)
      make.top.equalTo(recommenderNicknameLabel.snp.bottom).offset(20)
      make.width.equalTo(mainImgView.snp.height)
    }
    
    recommendLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(mainImgView.snp.bottom).offset(23)
    }
    
    recommendLabel2.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(recommendLabel.snp.bottom).offset(8.5)
    }

    recommendCodeTextField.snp.makeConstraints{ (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(recommendLabel2.snp.bottom).offset(10)
//      make.height.greaterThanOrEqualTo(20)
      make.left.right.equalToSuperview().inset(25)
      make.height.lessThanOrEqualTo(50)
    }
    
    confirmButton.snp.makeConstraints { (make) in
      make.top.equalTo(recommendCodeTextField.snp.bottom).offset(5)
      make.left.right.height.equalTo(recommendCodeTextField)
    }
    
    skipButton.snp.makeConstraints{ (make) in
      make.top.equalTo(confirmButton.snp.bottom).offset(5)
      make.left.right.height.equalTo(recommendCodeTextField)
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
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.bounds.origin.y = 0
        })
      }
    }
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height) != nil {
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.bounds.origin.y = 80
        })
      }
    }
  }
  
  override func swipeAction() {
    if isdisableScroll {
      let alertController = UIAlertController(title: "알림", message: "추천인 코드를 입력하거나\n건너뛰기 버튼을 눌러주세요", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  @objc fileprivate dynamic func deleteAction(){
    recommendCodeTextField.text = ""
  }
  
  @objc fileprivate dynamic func nextAction(){
    self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 6)
  }
  
  @objc fileprivate dynamic func confirmAction() {
    self.recommendCodeTextField.endEditing(true)
    let recommendCode = recommendCodeTextField.text
    
    if recommendCode?.count == 9 {
      CheeseService.provider
        .request(.checkRecommend(id: recommendCode ?? ""))
        .filter(statusCode: 200)
        .mapJSON()
        .map{JSON($0)}
        .subscribe(onSuccess: { (json) in
          if (json["result"]["code"].intValue == 200) {
            self.userSetupViewController?.signUp.recommend_code = recommendCode
            self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 6)
          } else {
            AlertView(title: json["result"]["data"].stringValue)
              .addChildAction(title: "확인", style: .default, handeler: nil)
              .show()
          }
        }, onError: { (err) in
          log.info(err)
        })
        .disposed(by: disposeBag)
    } else {
      let alertController = UIAlertController(title: "알림", message: "추천인 코드를 정확히 입력해주세요.", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
}

extension RecommendViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField.text?.count ?? 0) <= 1 {
      self.confirmButton.isSelected = false
      isdisableScroll = true
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
  
}
