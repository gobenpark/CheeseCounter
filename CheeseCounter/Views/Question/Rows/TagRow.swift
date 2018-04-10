//
//  TagRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 14..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa
import WSTagsField

public class TagCell: Cell<QuestionType>, CellType {
  
  private var disposeBag = DisposeBag()
  var isValid: Bool{
    get{
      return tagsField.tags.count != 0
    }
  }
  
  var tagText: String{
    get{
      var temp = tagSerlization()
      temp.removeLast()
      return temp
    }
  }
  
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
    field.placeholder = "태그 작성 후 Enter 입력(필수)"
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    return field
  }()

  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    height = {60}
    selectionStyle = .none
    contentView.addSubview(tagsField)
    
    tagsField.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview().inset(15)
      make.top.equalToSuperview()
    }

    tagsField.onDidChangeText = { field, text in
      if let text = text, text.contains(" ") {
        field.tokenizeTextFieldText()
      }
    }
  }
  
  public override func update() {
  }
  
  
  func tagSerlization() -> String{
    var tempString = String()
    for tag in tagsField.tags{
      tempString.append(tag.text)
      tempString.append(",")
    }
    return tempString
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class TagRow: Row<TagCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<TagCell>()
  }
}
