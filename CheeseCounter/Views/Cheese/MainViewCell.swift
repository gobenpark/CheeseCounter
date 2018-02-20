//
//  MainViewCell.swift
//  er
//
//  Created by xiilab on 2018. 1. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

enum MainSurveyAction{
  case Image(index: Int)
  case Button(index: Int)
}


final class MainViewCell: UICollectionViewCell{
  
  let disposeBag = DisposeBag()
  weak var cheeseVC: CheeseViewController?
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      self.mainView.model = model
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
      .map{return MainSurveyAction.Button(index: 1)}

    let button2 = mainView.selectView.imageButton2
      .rx
      .tap
      .map{return MainSurveyAction.Button(index: 2)}
    
    let button3 = mainView.selectView.imageButton3
      .rx
      .tap
      .map{return MainSurveyAction.Button(index: 3)}
    
    let button4 = mainView.selectView.imageButton4
      .rx
      .tap
      .map{return MainSurveyAction.Button(index: 4)}
    
    let image1 = mainView.selectView.circleView1
      .rx
      .tapGesture()
      .map{_ in return MainSurveyAction.Image(index: 1)}
    
    let image2 = mainView.selectView.circleView2
      .rx
      .tapGesture()
      .map{_ in return MainSurveyAction.Image(index: 2)}
    
    let image3 = mainView.selectView.circleView3
      .rx
      .tapGesture()
      .map{_ in return MainSurveyAction.Image(index: 3)}
    
    let image4 = mainView.selectView.circleView4
      .rx
      .tapGesture()
      .map{_ in return MainSurveyAction.Image(index: 4)}
    
    Observable<MainSurveyAction>
      .merge([button1,button2,button3,button4,image1,image2,image3,image4])
      .subscribe(onNext: { [weak self] (action) in
        guard let retainSelf = self, let retainModel = self?.model else {return}
        retainSelf.cheeseVC?.buttonEvent.onNext((action,retainModel))
      }).disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainView.moreButton.isHidden = mainView.title.isTruncated()
  }
}

