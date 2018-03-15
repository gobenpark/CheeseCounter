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
    field.placeholder = "태그 입력"
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
    
    tagsField.onDidAddTag = {[weak self] (_,_) in
      guard let `self` = self else {return}
      
      var tags = String()
      for tag in self.tagsField.tags{
        tags = tags+" "+tag.text
      }
      
      tags.remove(at: tags.startIndex)
    }
    
    tagsField.onDidRemoveTag = {[weak self] (_,_) in
      guard let `self` = self else {return}
      var tags = String()
      for tag in self.tagsField.tags{
        tags = tags+" "+tag.text
      }
      if self.tagsField.tags.count != 0 {
        tags.remove(at: tags.startIndex)
      }
    }
    
  }
  
  public override func update() {
    
    
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
