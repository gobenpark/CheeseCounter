//
//  TitleRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

public class TitleCell: Cell<NSAttributedString>, CellType {
  
  private var disposeBag = DisposeBag()
  
  lazy var titleField: UITextField = {
    let field = UITextField()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    field.leftView = paddingView
    field.leftViewMode = .always
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.font = UIFont.systemFont(ofSize: 12)
    return field
  }()
  
  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    height = {50}
    
    selectionStyle = .none
    contentView.addSubview(titleField)
    titleField.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview().inset(15)
      make.top.bottom.equalToSuperview()
    }
    
    titleField
      .rx
      .controlEvent(.editingDidEndOnExit)
      .subscribe {[weak self] (_) in
        self?.titleField.endEditing(true)
    }.disposed(by: disposeBag)
  }
  
  public override func update() {
    guard let holder = row.value else {return}
    titleField.attributedPlaceholder = holder
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class TitleRow: Row<TitleCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<TitleCell>()
  }
}
