//
//  SubmitRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 14..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

public class SubmitCell: Cell<QuestionType>, CellType {
  
  private var disposeBag = DisposeBag()
  
  private let submitButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 15.1)
    button.setTitle("내 질문 올리기", for: .normal)
    return button
  }()

  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    height = {46}
    selectionStyle = .none
    
    contentView.addSubview(submitButton)
    
    submitButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
  }
  
  public override func update() {
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class SubmitRow: Row<SubmitCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<SubmitCell>()
  }
}
