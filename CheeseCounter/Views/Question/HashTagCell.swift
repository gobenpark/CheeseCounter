//
//  HashTagCell.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import WSTagsField

class HashTagCell: UITableViewCell {
  
  static let ID = "HashTagCell"
  
  weak var questionViewController: QuestionTableViewController?{
    didSet{
      questionViewController?.questionData.hash_tag.components(separatedBy: " ").forEach({ (text) in
        if text.characters.count != 0{
          self.tagsField.addTag(text)
        }
      })
      
      if questionViewController?.questionData.hash_tag.characters.count == 0 {
        self.tagsField.removeTags()
      }
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "태그"
    label.font = UIFont.CheeseFontMedium(size: 15)
    label.sizeToFit()
    return label
  }()
  
  let tagsField: WSTagsField = {
    let field = WSTagsField()
    field.spaceBetweenTags = 10
    field.font = UIFont.CheeseFontMedium(size: 12)
    field.fieldTextColor = .black
    field.tintColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
    field.textColor = .black
    field.selectedColor = .lightGray
    field.selectedTextColor = .white
    field.delimiter = " "
    field.onDidChangeText = { field, text in
        if let text = text, text.contains(" ") {
            field.tokenizeTextFieldText()
        }
    }
    field.placeholder = "태그 입력"
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    return field
  }()
  
  let dividView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  var parameterString:String?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .white
    self.selectionStyle = .none
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(tagsField)
    self.contentView.addSubview(dividView)
    
    titleLabel.snp.makeConstraints{
      $0.left.equalTo(self.snp.left).inset(25)
      $0.top.equalTo(self.snp.topMargin)
      $0.height.equalTo(25)
    }
    
    tagsField.snp.makeConstraints{
      $0.left.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.right.equalTo(self.snp.right).inset(25)
      $0.bottom.equalTo(self.snp.bottomMargin)
    }
    
    dividView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalToSuperview()
      make.height.equalTo(0.5)
    }
    
    tagsField.onDidAddTag = {[weak self] (_,_) in
      guard let `self` = self else {return}
      
      var tags = String()
      for tag in self.tagsField.tags{
        tags = tags+" "+tag.text
      }
      
      tags.remove(at: tags.startIndex)
      self.questionViewController?.questionData.hash_tag = tags
      
    }
    
    tagsField.onDidRemoveTag = {[weak self] (_,_) in
      guard let `self` = self else {return}
      var tags = String()
      for tag in self.tagsField.tags{
        tags = tags+" "+tag.text
      }
      if self.tagsField.tags.count != 0 {
        tags.remove(at: tags.startIndex)
        self.questionViewController?.questionData.hash_tag = tags
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


