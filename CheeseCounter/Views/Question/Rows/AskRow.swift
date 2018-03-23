//
//  AskRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

public class AskCell: Cell<Bool>, CellType {
  
  private var disposeBag = DisposeBag()
  var isValid: Bool = false
  
  lazy var ask1Field: UITextField = {
    let field = UITextField()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    field.leftView = paddingView
    field.leftViewMode = .always
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.font = UIFont.systemFont(ofSize: 12)
    field.attributedPlaceholder = NSAttributedString(string: "보기 입력 (필수)",
                                                     attributes: [NSAttributedStringKey.font:UIFont.CheeseFontRegular(size: 14.8)])
    return field
  }()
  
  lazy var ask2Field: UITextField = {
    let field = UITextField()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
    field.leftView = paddingView
    field.leftViewMode = .always
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.lightGray.cgColor
    field.font = UIFont.systemFont(ofSize: 12)
    field.attributedPlaceholder = NSAttributedString(string: "보기 입력 (필수)",
                                                     attributes: [NSAttributedStringKey.font:UIFont.CheeseFontRegular(size: 14.8)])
    return field
  }()
  
  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    selectionStyle = .none
    height = {70}
    
    contentView.addSubview(ask1Field)
    contentView.addSubview(ask2Field)
    
    ask1Field.snp.makeConstraints { (make) in
      make.top.left.bottom.equalToSuperview().inset(15)
      make.right.equalTo(self.snp.centerX).inset(-5)
    }
    
    ask2Field.snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.centerX).inset(5)
      make.right.top.bottom.equalToSuperview().inset(15)
    }
    
    let ask1 = ask1Field.rx
      .controlEvent(.editingDidEndOnExit)
      .asObservable()
      .map{[unowned self] _ in return self.ask1Field }
    
    let ask2 = ask2Field.rx
      .controlEvent(.editingDidEndOnExit)
      .asObservable()
      .map{[unowned self] _ in return self.ask2Field}
    
    Observable<UITextField>.merge([ask1,ask2])
      .subscribe(onNext: { (field) in
        field.endEditing(true)
      }).disposed(by: disposeBag)
    
    let field1Valid = ask1Field.rx.text.orEmpty
      .map{$0.count >= 1}
      .share()
    let field2Valid = ask2Field.rx.text.orEmpty
      .map{$0.count >= 1}
      .share()
    
    Observable<Bool>.combineLatest(field1Valid, field2Valid) { $0 && $1}
      .subscribe(onNext: {[weak self] (result) in
        guard let `self` = self else {return}
        self.isValid = result
      }).disposed(by: disposeBag)
  }
  
  public override func update() {
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class AskRow: Row<AskCell>, RowType {
  
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<AskCell>()
  }
}
