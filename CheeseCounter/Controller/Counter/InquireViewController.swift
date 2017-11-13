//
//  InquireViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import NextGrowingTextView

class InquireViewController: UIViewController {
  
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "제목"
    label.font = UIFont.CheeseFontMedium(size: 18)
    label.sizeToFit()
    return label
  }()
  
  lazy var titleTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "제목 입력(필수)"
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    textField.leftViewMode = .always
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    button.setImage(#imageLiteral(resourceName: "share_close@1x").withRenderingMode(.alwaysTemplate), for: .normal)
    textField.rightView = button
    textField.rightViewMode = .whileEditing
    textField.delegate = self
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()
  
  fileprivate let commentLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 18)
    label.text = "내용"
    return label
  }()
  
  lazy var commentTextView: UITextView = {
    let textView = UITextView()
    textView.delegate = self
    textView.layer.borderWidth = 0.5
    textView.layer.borderColor = UIColor.lightGray.cgColor
    return textView
  }()
  
  fileprivate let alertLabel: UILabel = {
    let label = UILabel()
    label.text = "입력하신 개인정보 및 결제정보는 고객님의 문의내용을 처리하기 위해\n"
      + "사용되며,다른 용도로 사용하지 않습니다.\n"
      + "수집된 개인정보(아이디)와 기기정보(모델명,OS버전)는 전자상거래법에\n"
      + "따라 3년간 보관 후 삭제됩니다."
    label.font = UIFont.CheeseFontLight(size: 11)
    label.lineBreakMode = .byWordWrapping
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.sizeToFit()
    return label
  }()
  
  lazy var commitButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_2_nomal@1x"), for: .normal)
    button.setTitle("문의하기", for: .normal)
    button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    return button
  }()
  
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isScrollEnabled = true
    view.delegate = self
    return view
  }()
  
  override func viewDidLoad(){
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(scrollView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
    scrollView.addGestureRecognizer(tapGesture)
    
    
    self.scrollView.addSubview(titleLabel)
    self.scrollView.addSubview(titleTextField)
    self.scrollView.addSubview(commentLabel)
    self.scrollView.addSubview(commentTextView)
    self.scrollView.addSubview(alertLabel)
    self.scrollView.addSubview(commitButton)
    
    
    scrollView.snp.makeConstraints(){
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(25)
      make.top.equalToSuperview().offset(25)
    }
    
    titleTextField.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    commentLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(titleTextField.snp.bottom).offset(10)
    }
    
    commentTextView.snp.makeConstraints { (make) in
      make.left.equalTo(commentLabel)
      make.top.equalTo(commentLabel.snp.bottom).offset(10)
      make.height.equalToSuperview().dividedBy(2.5)
      make.right.equalToSuperview().inset(25)
    }
    
    alertLabel.snp.makeConstraints { (make) in
      make.top.equalTo(commentTextView.snp.bottom)
      make.left.equalTo(commentTextView)
      make.right.equalTo(commentTextView)
    }
    
    commitButton.snp.makeConstraints { (make) in
      make.top.equalTo(alertLabel.snp.bottom).offset(10)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
  }
  
  
  @objc func tapGestureAction(){
    self.commentTextView.endEditing(true)
  }
  
  @objc fileprivate dynamic func submitAction(){
    if (titleTextField.text?.characters.count ?? 0) > 1 &&
      (commentTextView.text?.characters.count ?? 0) > 1{
      upLoadQna()
    } else {
      let alertController = UIAlertController(title: "알림", message: "1자 이상 입력하세요", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  fileprivate func upLoadQna(){
    let title = self.titleTextField.text ?? ""
    let comment = self.commentTextView.text ?? ""
    CheeseService.insertQna(parameter: ["title":title,"contents":comment]) { (code) in
      if code == "200"{
        let alertController = UIAlertController(title: "알림", message: "등록되었습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
          self.titleTextField.text = ""
          self.commentTextView.text = ""
        }))
        self.present(alertController, animated: true, completion: nil)
      } else {
        let alertController = UIAlertController(title: "알림", message: "등록에 실패하였습니다.\n관리자에게 문의바랍니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
        }))
        self.present(alertController, animated: true, completion: nil)
      }
    }
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    scrollView.contentSize = CGSize(width: 375, height: self.view.frame.height+100)
    scrollView.zoomScale = 1
  }
}

extension InquireViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if textView.text.characters.count > 1 {
      self.commitButton.isEnabled = true
      self.commitButton.setBackgroundImage(#imageLiteral(resourceName: "btn_gradation@1x"), for: .normal)
    } else {
      self.commitButton.isEnabled = false
      self.commitButton.setBackgroundImage(#imageLiteral(resourceName: "txt_box_2_nomal@1x"), for: .normal)
    }
  }
}

extension InquireViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    
  }
}
extension InquireViewController: UIScrollViewDelegate{
  
}




