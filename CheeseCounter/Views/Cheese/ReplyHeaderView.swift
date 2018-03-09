//
//  ReplyHeaderView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 6..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class ReplyHeaderView: UICollectionReusableView{
  
  let disposeBag = DisposeBag()
  weak var replyViewController: ReplyViewController?
  var model: MainSurveyList.CheeseData?{
    didSet{
      mainView.model = model
    }
  }
  
  let mainView = MainCheeseView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(mainView)
    
    mainView.commentButton.isHidden = true
    
    mainView.shareButton.rx.tap
      .subscribe(onNext: {[weak self] (_) in
        self?.replyViewController?.shareEvent.onNext(true)
      }).disposed(by: disposeBag)
    
    mainView.heartButton
      .rx
      .tap
      .subscribe(onNext: {[weak self] (_) in
        self?.replyViewController?.empathyAction.onNext(true)
        self?.mainView.heartButton.isSelected = true
      }).disposed(by: disposeBag)
    
    mainView.emptyReplyLabel
      .rx
      .tapGesture()
      .when(.ended)
      .subscribe(onNext: {[weak self] (_) in
        self?.replyViewController?.empathyAction.onNext(true)
      }).disposed(by: disposeBag)
    
    let circleView1 = mainView.selectView.circleView1.rx.tapGesture().when(.ended).map{_ in return 1}.asObservable()
    let circleView2 = mainView.selectView.circleView2.rx.tapGesture().when(.ended).map{_ in return 2}.asObservable()
    let circleView3 = mainView.selectView.circleView3.rx.tapGesture().when(.ended).map{_ in return 3}.asObservable()
    let circleView4 = mainView.selectView.circleView4.rx.tapGesture().when(.ended).map{_ in return 4}.asObservable()
    
    Observable<Int>
      .merge([circleView1,circleView2,circleView3,circleView4])
      .subscribe (onNext:{[weak self] (idx) in
        self?.replyViewController?.detailAction.onNext(idx)
      }).disposed(by:disposeBag)
    
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
