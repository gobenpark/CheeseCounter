//
//  SelectTypeRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

public class SelectionButtonCell: Cell<QuestionType>, CellType {
  
  private var disposeBag = DisposeBag()
  
  private let divideLine: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    return view
  }()
  
  lazy var secondWayButton: UIButton = {
    let button = UIButton()
    button.setTitle("2지 선다", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 1, green: 0.4823529412, blue: 0.2745098039, alpha: 1), for: .selected)
    button.tag = 0
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 14.8)
    return button
  }()
  
  lazy var fourWayButton: UIButton = {
    let button = UIButton()
    button.setTitle("4지 선다", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 1, green: 0.4823529412, blue: 0.2745098039, alpha: 1), for: .selected)
    button.tag = 1
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 14.8)
    return button
  }()
  
  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    height = {60}
    selectionStyle = .none
    
    contentView.addSubview(secondWayButton)
    contentView.addSubview(fourWayButton)
    contentView.addSubview(divideLine)
    
    secondWayButton.snp.makeConstraints { (make) in
      make.right.equalTo(self.snp.centerX).inset(9)
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(9)
      make.height.equalToSuperview().dividedBy(1.3)
    }
    
    fourWayButton.snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.centerX).inset(-9)
      make.right.equalToSuperview().inset(9)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(1.3)
    }
    
    divideLine.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.bottom.equalToSuperview().inset(10)
      make.width.equalTo(1)
    }
    
    let second = secondWayButton.rx
      .tap
      .map{[unowned self] in
        return self.secondWayButton
      }
      .asObservable()
    
    let four = fourWayButton.rx
      .tap
      .map{[unowned self] in
        return self.fourWayButton
      }
      .asObservable()
    
    
    Observable<UIButton>.merge([second,four])
      .subscribe(onNext: {[weak self] (button) in
        if button.tag == 0{
          self?.row.value = .Two
        }else{
          self?.row.value = .Four
        }
        self?.row.updateCell()
      }).disposed(by: disposeBag)
  }
  
  public override func update() {
    
    guard let questionType = row.value else {return}
    switch questionType{
    case .Two:
      secondWayButton.isSelected = true
      fourWayButton.isSelected = false
    case .Four:
      secondWayButton.isSelected = false
      fourWayButton.isSelected = true
    }
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class SelectionButtonRow: Row<SelectionButtonCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<SelectionButtonCell>()
  }
}
