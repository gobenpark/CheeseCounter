//
//  SelectImageCell2.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//
//
//  SelectImageCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectImageCell2: UITableViewCell {
  
  static let ID = "SelectImageCell2"
  
  var questionViewController: QuestionTableViewController?{
    didSet{
      self.imgView.image = #imageLiteral(resourceName: "question_img_nomal@1x")
      self.imgView1.image = #imageLiteral(resourceName: "question_img_nomal@1x")
      if questionViewController?.dataParameters.index3 != "none"{
        let url = (questionViewController?.dataParameters.index3 ?? "")
        self.imgView.kf.setImage(with: URL(string: url))
      }
      
      if questionViewController?.dataParameters.index4 != "none"{
        let url = (questionViewController?.dataParameters.index4 ?? "")
        self.imgView1.kf.setImage(with: URL(string: url))
      }
      
      if let imgData = questionViewController?.dataParameters.file3{
        self.imgView.image = UIImage(data: imgData)
      }
      
      if let imgData = questionViewController?.dataParameters.file4{
        self.imgView1.image = UIImage(data: imgData)
      }
      
      textField.text = self.questionViewController?.questionData.ask3
      textField1.text = self.questionViewController?.questionData.ask4
    }
  }
  var naviVC = UINavigationController(rootViewController: SampleImageSelectVC())
  //셀구별을 위함
  var isTopCell:Bool = true
  var index = 0
  
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "보기 입력(필수)"
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
    textField.font = UIFont.systemFont(ofSize: 12)
    textField.placeholder = "보기 입력(필수)"
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
  
  let dividedLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    self.backgroundColor = .white
    contentView.addSubview(textField)
    contentView.addSubview(textField1)
    contentView.addSubview(imgView)
    contentView.addSubview(imgView1)
    contentView.addSubview(dividedLine)
    
    imgView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.snp.centerX).inset(-5)
      make.top.equalToSuperview().inset(5)
      make.height.equalTo((self.frame.width/2)-20)
    }
    
    imgView1.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.height.equalTo((self.frame.width/2)-20)
      make.top.equalTo(imgView)
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
    
    dividedLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(0.5)
    }
  }
  
  @objc fileprivate dynamic func imagePickerAction(_ sender: UIImageView){
    let imagePicker = ImagePickerViewController()
    imagePicker.urlCallBack = { [weak self](urlString) in
      guard let `self` = self else { return }
      let url = URL(string: UserService.imgString+urlString)
      self.imgView.kf.setImage(with: url)
      self.questionViewController?.dataParameters.index3 = UserService.imgString+urlString
    }
    
    imagePicker.didTap = {[weak self] (data) in
      guard let `self` = self else {return}
      self.imgView.image = UIImage(data: data)
      self.questionViewController?.dataParameters.file3 = data
    }
    self.questionViewController?.navigationController?.pushViewController(imagePicker, animated: true)
  }
  
  @objc fileprivate dynamic func imagePickerAction1(_ sender: UIImageView){
    let imagePicker = ImagePickerViewController()
    imagePicker.urlCallBack = { [weak self](urlString) in
      guard let `self` = self else {return}
      let url = URL(string: UserService.imgString+urlString)
      self.imgView1.kf.setImage(with: url)
      self.questionViewController?.dataParameters.index4 = UserService.imgString+urlString
    }
    
    imagePicker.didTap = { (data) in
      self.imgView1.image = UIImage(data: data)
      self.questionViewController?.dataParameters.file4 = data
    }
    
    self.questionViewController?.navigationController?.pushViewController(imagePicker, animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension SelectImageCell2: UITextFieldDelegate{
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.tag == 0 {
      self.questionViewController?.questionData.ask3 = textField.text ?? ""
    } else {
      self.questionViewController?.questionData.ask4 = textField.text ?? ""
    }
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.endEditing(true)
    return false
  }
}
