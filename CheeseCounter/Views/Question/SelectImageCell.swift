//
//  SelectImageCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectImageCell: UITableViewCell {
  
  static let ID = "SelectImageCell"
  
  var questionViewController: QuestionTableViewController?{
    didSet{
      
      self.imgView.image = #imageLiteral(resourceName: "question_img_nomal@1x")
      self.imgView1.image = #imageLiteral(resourceName: "question_img_nomal@1x")
      if questionViewController?.dataParameters.index1 != "none"{
        let url = (questionViewController?.dataParameters.index1 ?? "")
        self.imgView.kf.setImage(with: URL(string: url))
      }
      
      if questionViewController?.dataParameters.index2 != "none"{
        let url = (questionViewController?.dataParameters.index2 ?? "")
        self.imgView1.kf.setImage(with: URL(string: url))
      }
      
      if let imgData = questionViewController?.dataParameters.file1{
        self.imgView.image = UIImage(data: imgData)
      }
      
      if let imgData = questionViewController?.dataParameters.file2{
        self.imgView1.image = UIImage(data: imgData)
      }
      
      textField.text = self.questionViewController?.questionData.ask1
      textField1.text = self.questionViewController?.questionData.ask2
    }
  }
  
  var naviVC = UINavigationController(rootViewController: SampleImageSelectVC())
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(string: "보기 입력(필수)", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontRegular(size: 14.8)])
    textField.font = UIFont.systemFont(ofSize: 12)
    textField.textAlignment = .center
    textField.tag = 0
    textField.delegate = self
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()
  
  lazy var textField1: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(string: "보기 입력(필수)", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontRegular(size: 14.8)])
    textField.font = UIFont.systemFont(ofSize: 12)
    textField.textAlignment = .center
    textField.tag = 1
    textField.delegate = self
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()
  
  lazy var imgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal))
    img.addGestureRecognizer(UITapGestureRecognizer(target: self
      , action: #selector(self.imagePickerAction(_:))))
    img.isUserInteractionEnabled = true
    img.layer.masksToBounds = true
    img.contentMode = .scaleAspectFill
    img.tag = 0
    return img
  }()
  
  lazy var imgView1: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal))
    img.addGestureRecognizer(UITapGestureRecognizer(target: self
      , action: #selector(self.imagePickerAction1(_:))))
    img.isUserInteractionEnabled = true
    img.layer.masksToBounds = true
    img.contentMode = .scaleAspectFill
    img.tag = 0
    return img
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    self.backgroundColor = .white
    addSubview(textField)
    addSubview(textField1)
    addSubview(imgView)
    addSubview(imgView1)
    
    imgView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.snp.centerX).inset(-5)
      make.top.equalToSuperview()
      make.height.equalTo((self.frame.width/2)-20)
    }
    
    imgView1.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.height.equalTo((self.frame.width/2)-20)
      make.top.equalToSuperview()
      make.left.equalTo(self.snp.centerX).inset(5)
    }
    
    textField.snp.makeConstraints { (make) in
      make.left.equalTo(imgView)
      make.right.equalTo(imgView)
      make.top.equalTo(imgView.snp.bottom).offset(10)
      make.height.equalTo(43)
    }
    
    textField1.snp.makeConstraints { (make) in
      make.right.equalTo(imgView1)
      make.left.equalTo(imgView1)
      make.top.equalTo(imgView1.snp.bottom).offset(10)
      make.height.equalTo(43)
    }
  }
  
  @objc fileprivate dynamic func imagePickerAction(_ sender: UIImageView){
    
    let imagePicker = ImagePickerViewController()
    imagePicker.urlCallBack = { [weak self](urlString) in
      guard let `self` = self else { return }
      let url = URL(string: UserService.imgString+urlString)
      self.imgView.kf.setImage(with: url)
      self.questionViewController?.dataParameters.index1 = UserService.imgString+urlString
    }
    
    imagePicker.didTap = {[weak self] (data) in
      guard let `self` = self else {return}
      self.imgView.image = UIImage(data: data)
      self.questionViewController?.dataParameters.file1 = data
    }
    self.questionViewController?.navigationController?.pushViewController(imagePicker, animated: true)
  }
  
  @objc fileprivate dynamic func imagePickerAction1(_ sender: UIImageView){
    
    let imagePicker = ImagePickerViewController()
    imagePicker.urlCallBack = { [weak self](urlString) in
      guard let `self` = self else {return}
      let url = URL(string: UserService.imgString+urlString)
      self.imgView1.kf.setImage(with: url)
      self.questionViewController?.dataParameters.index2 = UserService.imgString+urlString
    }
    
    imagePicker.didTap = { (data) in
      self.imgView1.image = UIImage(data: data)
      self.questionViewController?.dataParameters.file2 = data
    }
    self.questionViewController?.navigationController?.pushViewController(imagePicker, animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SelectImageCell: UITextFieldDelegate{
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if textField.tag == 0 {
      self.questionViewController?.questionData.ask1 = textField.text ?? ""
    }
    if textField.tag == 1 {
      self.questionViewController?.questionData.ask2 = textField1.text ?? ""
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.endEditing(true)
    return false
  }
}

