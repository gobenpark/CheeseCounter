//
//  ImageRow.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

public class QuestionImageView: UIImageView{
  var imageURL: String?
}

public class ImageCell: Cell<QuestionModel>, CellType {
  
  private var disposeBag = DisposeBag()
  
  var isValid: Bool{
    get{
      return (firstImgView.image != nil && secondImgView.image != nil)
    }
  }
  
  lazy var firstImgView: QuestionImageView = {
    let img = QuestionImageView(image: #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal))
    img.isUserInteractionEnabled = true
    img.layer.masksToBounds = true
    img.contentMode = .scaleAspectFill
    img.tag = 0
    return img
  }()
  
  lazy var secondImgView: QuestionImageView = {
    let img = QuestionImageView(image: #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal))
    img.isUserInteractionEnabled = true
    img.layer.masksToBounds = true
    img.contentMode = .scaleAspectFill
    img.tag = 0
    return img
  }()
  
  var touchEvent: Observable<QuestionImageView>?
  
  public override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  public override func setup() {
    super.setup()
    
    height = {161}
    selectionStyle = .none
    
    contentView.addSubview(firstImgView)
    contentView.addSubview(secondImgView)
    
    let firstimgEvent = firstImgView.rx
      .tapGesture()
      .when(.ended)
      .map{[unowned self]_ in self.firstImgView}
      .asObservable()
    
    let secondImgEvent = secondImgView.rx
      .tapGesture()
      .when(.ended)
      .map{[unowned self] _ in self.secondImgView}
      .asObservable()
    
    touchEvent = Observable<QuestionImageView>.merge([firstimgEvent,secondImgEvent])

    firstImgView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(15)
      make.right.equalTo(self.snp.centerX).inset(-5)
      make.top.bottom.equalToSuperview()
    }
    
    secondImgView.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(15)
      make.top.bottom.equalToSuperview()
      make.left.equalTo(self.snp.centerX).inset(5)
    }
  }
  
  public override func update() {
  }
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class ImageRow: Row<ImageCell>, RowType {
  required public init(tag: String?) {
    super.init(tag: tag)
    // We set the cellProvider to load the .xib corresponding to our cell
    cellProvider = CellProvider<ImageCell>()
  }
}
