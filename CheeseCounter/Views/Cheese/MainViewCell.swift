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
  
  weak var cheeseVC: CheeseViewController?
  private let disposeBag = DisposeBag()
  
//  let selectImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "img_select@1x"))
  let selectImage = SelectedImageView()
  
  
  var indexPath: IndexPath?
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
    
    mainView
      .emptyReplyLabel
      .rx
      .tapGesture()
      .when(.ended)
      .subscribe {[weak self] (_) in
        guard let vc = self?.cheeseVC, let idx = self?.indexPath else {return}
        vc.replyEvent.onNext(idx)
    }.disposed(by: disposeBag)
    
    mainView.heartButton
      .rx
      .tap
      .subscribe { [weak self](_) in
        guard let id = self?.model?.id, let idx = self?.indexPath else {return}
        self?.cheeseVC?.empathyEvent.onNext((id,idx))
      }.disposed(by: disposeBag)
    
    mainView.moreButton.isUserInteractionEnabled = true
    
    mainView.moreButton
      .rx
      .tap
      .subscribe {[weak self] (_) in
        guard let vc = self?.cheeseVC ,
          let idx = self?.indexPath else {return}
        vc.moreEvent.onNext(idx)
        
      }.disposed(by: disposeBag)
    
    mainView.commentButton.rx.tap
      .subscribe { [weak self] (_) in
        guard let vc = self?.cheeseVC ,
          let idx = self?.indexPath else {return}
        vc.replyEvent.onNext(idx)
        
      }.disposed(by: disposeBag)
    
    mainView.shareButton.rx.tap
      .subscribe(onNext: {[weak self] (_) in
        guard let idx = self?.indexPath ,
          let vc = self?.cheeseVC else {return}
        vc.shareEvent.onNext(idx)
        
      }).disposed(by: disposeBag)
    
    Observable<MainSurveyAction>
      .merge([button1,button2,button3,button4,image1,image2,image3,image4])
      .subscribe(onNext: { [weak self] (action) in
        guard let retainSelf = self, let retainModel = self?.model else {return}
        retainSelf.cheeseVC?.buttonEvent.onNext((action,retainModel,retainSelf.indexPath))
        
        
      }).disposed(by: disposeBag)
    
    Observable<MainSurveyAction>
      .merge([button1,button2,button3,button4])
      .map{ idx in
        guard case let .Button(index) = idx else {return 0}
        return index
      }.bind(onNext: selectImageSetting)
      .disposed(by: disposeBag)
  }
  
  private func selectImageSetting(index: Int){
    mainView.addSubview(selectImage)

    if index == 1{
      selectImage.snp.remakeConstraints { (make) in
        make.edges.equalTo(mainView.selectView.imageButton1)
      }
    }else if index == 2{
      selectImage.snp.remakeConstraints { (make) in
        make.edges.equalTo(mainView.selectView.imageButton2)
      }
    }else if index == 3 {
      selectImage.snp.remakeConstraints { (make) in
        make.edges.equalTo(mainView.selectView.imageButton3)
      }
    }else if index == 4{
      selectImage.snp.remakeConstraints { (make) in
        make.edges.equalTo(mainView.selectView.imageButton4)
      }
    }
  }

//  override func layoutSubviews() {
//    super.layoutSubviews()
//    //if let model = model, !model.isExpand {
//      mainView.moreButton.isHidden = !mainView.title.isTruncated()
//    //}
//  }
}

class SelectedImageView: UIView {
  
  let imageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "icAnswerCheck"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    self.backgroundColor = .yellow
    self.alpha = 0.5
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.size.equalToSuperview().dividedBy(2)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
