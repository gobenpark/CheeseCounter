//
//  titleViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

class TitleViewCell: UITableViewCell {
  
  static let ID = "TitleViewCell"
  
  weak var questionViewController: QuestionTableViewController?{
    didSet{
      titleField.text = questionViewController?.questionData.title
    }
  }
  
  lazy var titleField: UITextField = {
    let field = UITextField()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    field.leftView = paddingView
    field.leftViewMode = .always
    field.attributedPlaceholder = NSAttributedString(string: "질문 입력(필수)", attributes: [NSFontAttributeName:UIFont.CheeseFontMedium(size: 12)])
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.delegate = self
    field.font = UIFont.systemFont(ofSize: 12)
    return field
  }()
  
  var parameterString:String?
  
  let dividedLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .white
    self.selectionStyle = .none
    self.addSubview(titleField)
    self.contentView.addSubview(dividedLine)
    
    titleField.snp.makeConstraints{
      $0.left.equalToSuperview().inset(25)
      $0.top.equalTo(self.snp.topMargin).inset(1)
      $0.right.equalTo(self.snp.right).inset(25)
      $0.bottom.equalTo(self.snp.bottomMargin)
    }
    
    dividedLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(0.5)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TitleViewCell: UITextFieldDelegate{
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    questionViewController?.questionData.title = textField.text ?? ""
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.endEditing(true)
    return false
  }
}

