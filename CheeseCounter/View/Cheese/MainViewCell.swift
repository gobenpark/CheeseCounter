//
//  MainViewCell.swift
//  er
//
//  Created by xiilab on 2018. 1. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import TTTAttributedLabel
import AnyDate

final class MainViewCell: UICollectionViewCell{
  
  let disposeBag = DisposeBag()
  weak var cheeseVC: CheeseViewController?
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      mainView.selectView.model = model
      mainView.title.text = model?.title
      mainView.cheeseCount.text = model?.option_cut_cheese
      mainView.peopleCount.text = model?.total_count
      mainView.calendarLabel.text = dateConvert(model: model)
      mainView.heartLabel.text = model?.empathy_count
      
      if let type = model?.type{
        if type == "2"{
          mainView.selectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(mainView.selectView.snp.width).dividedBy(2)
            make.right.equalToSuperview()
            make.bottom.equalTo(mainView.dividLine.snp.top).offset(-33.5)
          }
        }else {
          mainView.selectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(mainView.selectView.snp.width)
            make.right.equalToSuperview()
            make.bottom.equalTo(mainView.dividLine.snp.top).offset(-33.5)
          }
        }
      }
      
      mainView.cheeseCount.sizeToFit()
      mainView.peopleIcon.sizeToFit()
      mainView.peopleCount.sizeToFit()
      mainView.calendarLabel.sizeToFit()
    }
  }
  
  let mainView = MainCheeseView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(mainView)
    
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    subjectBind()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func subjectBind(){
    
    let button1 = mainView.selectView.imageButton1
      .rx
      .tap
      .map{return 1}
      .share()
    let button2 = mainView.selectView.imageButton2
      .rx
      .tap
      .map{return 2}
      .share()
    
    let button3 = mainView.selectView.imageButton3
      .rx
      .tap
      .map{return 3}
      .share()
    
    let button4 = mainView.selectView.imageButton4
      .rx
      .tap
      .map{return 4}
      .share()
    
    Observable<Int>.merge([button1,button2,button3,button4])
      .subscribe(onNext: { [weak self] (index) in
        guard let retainSelf = self, let retainModel = self?.model else {return}
        retainSelf.cheeseVC?.buttonEvent.onNext((index,retainModel))
      }).disposed(by: disposeBag)
    
//    moreButton.rx.tap
//      .map { [weak self](_) in
//        return self?.indexPath}
//      .bind(to: moreEvent!)
//    .disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainView.moreButton.isHidden = mainView.title.isTruncated()
  }
  
  private func dateConvert(model: MainSurveyList.CheeseData?) -> String?{
    guard let mainModel = model else {return nil}
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
    guard let limitTime = ZonedDateTime.parse(mainModel.limit_date, formatter: dateFormatter),
    let startTime = ZonedDateTime.parse(mainModel.created_date, formatter: dateFormatter) else {return nil}
    
    return "\(startTime.year-2000)/\(startTime.month)/\(startTime.day) ~ \(limitTime.year-2000)/\(limitTime.month)/\(limitTime.day)"
  }
}

