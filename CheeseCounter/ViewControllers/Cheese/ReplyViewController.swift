//
//  ReplyViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 6..
//  Copyright © 2018년 xiilab. All rights reserved.
//  한개의 데이터를 리프레시후 모델 삽입 메인도 똑같이 적용 예정

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import Moya
import NextGrowingTextView
import Toaster
import SwiftyJSON
import SnapKit

final class ReplyViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let provider = MoyaProvider<CheeseCounter>().rx
  private let refreshView = UIRefreshControl()
  private let indexPath: IndexPath
  
  let writeReplySubject = PublishSubject<ReplyActionData>()
  let dataSubject = Variable<[ReplyViewModel]>([])
  let messageInputBar = MessageInputBar()
  let empathyAction = PublishSubject<Bool>()
  let shareEvent = PublishSubject<Bool>()
  let detailAction = PublishSubject<Int>()
  let replyEmpathyAction = PublishSubject<Bool>()
  let deleteReplyAction = PublishSubject<(ReplyModel.Data, IndexPath)>()
  
  private var didSetupViewConstraints = false
  var boxBottomConstraint: Constraint?
  var model: MainSurveyList.CheeseData
  let updateSurvey: ((_ model: MainSurveyList.CheeseData, _ indexPath: IndexPath) -> Void)?
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<ReplyViewModel>(configureCell: { ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: ReplyViewCell.self), for: idx) as! ReplyViewCell
    cell.model = item
    cell.parentViewController = self
    return cell
  },configureSupplementaryView: {[unowned self] ds,cv,item,idx in
    let view = cv.dequeueReusableSupplementaryView(
      ofKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: String(describing: ReplyHeaderView.self),
      for: idx) as! ReplyHeaderView
    view.model = self.model
    view.mainView.moreButton.isHidden = true
    view.replyViewController = self
    return view
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    if model.type == "2"{
      layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 350)
    }else {
      layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 520)
    }
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ReplyHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: ReplyHeaderView.self))
    collectionView.register(ReplyViewCell.self, forCellWithReuseIdentifier: String(describing: ReplyViewCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    collectionView.keyboardDismissMode = .interactive
    if #available(iOS 11, *){
      collectionView.insetsLayoutMarginsFromSafeArea = true
    }
    return collectionView
  }()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  init(model: MainSurveyList.CheeseData, indexPath: IndexPath = IndexPath(), updateSurvey: (((_ model: MainSurveyList.CheeseData, _ indexPath: IndexPath) -> Void))? = nil) {
    
    self.model = model
    self.indexPath = indexPath
    self.updateSurvey = updateSurvey
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "댓글"
    view.addSubview(collectionView)
    collectionView.addSubview(refreshView)
    view.addSubview(messageInputBar)
    ToastView.appearance().bottomOffsetPortrait = 200
    navigationBarSetup()
    addConstraint()
    replyRequest()
    
    shareEvent
      .subscribe(onNext: {[weak self] (_) in
        guard let `self` = self else {return}
        self.present(ShareController.shareActionSheet(model: self.model, fromViewController: self), animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    empathyAction
      .flatMap { [unowned self] _ in
        return CheeseService.provider
          .request(.insertEmpathy(id: self.model.id))
          .filter(statusCode: 200)
          .mapJSON()
          .map{JSON($0)}
          .asObservable()
      }.flatMap {[unowned self] (_)  in
        return CheeseService
          .provider
          .request(.getSurveyByIdV2(id: self.model.id))
          .map(MainSurveyList.self)
          .asObservable()
      }.subscribe(onNext: {[weak self] (model) in
        guard let model = model.result.data.first, let `self` = self else {return}
        self.model = model
        self.collectionView.reloadSections([0], animationStyle: .none)
        self.updateSurvey?(self.model, self.indexPath)
      }).disposed(by: disposeBag)
    
    refreshView.rx.controlEvent(.valueChanged)
      .do(onNext: {[weak self] (_) in
        self?.refreshView.beginRefreshing()
      }).bind(onNext: replyRequest)
      .disposed(by: disposeBag)
    
    dataSubject.asDriver()
      .do(onNext: { [weak self](_) in
        self?.refreshView.endRefreshing()
      })
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    replyEmpathyAction
      .subscribe {[weak self] (_) in
        self?.replyRequest()
      }.disposed(by: disposeBag)
    
    writeReplySubject
      .asDriver(onErrorJustReturn: ReplyActionData(nickname: String(), parentID: String()))
      .do(onNext: {[weak self] (_) in
        self?.messageInputBar.textView.textView.becomeFirstResponder()
      })
      .drive(onNext: {[weak self] data in
        guard let `self` = self else {return}
        self.messageInputBar.replyType = .ReReply(replyData: data)
      })
      .disposed(by: disposeBag)
    
    writeReplySubject
      .flatMap {[unowned self] (_)  in
        return CheeseService
          .provider
          .request(.getSurveyByIdV2(id: self.model.id))
          .map(MainSurveyList.self)
          .asObservable()
      }.subscribe(onNext: {[weak self] (model) in
        guard let model = model.result.data.first, let `self` = self else {return}
        self.model = model
        self.collectionView.reloadSections([0], animationStyle: .none)
        self.updateSurvey?(self.model, self.indexPath)
      }).disposed(by: disposeBag)
    
    deleteReplyAction
      .flatMap {(data) in
        return CheeseService.provider
          .request(.deleteReply(id: data.0.id))
          .filter(statusCode: 200)
          .map{ _ in return data }
          .asObservable()}
      .flatMap { (data) in
        CheeseService.provider
          .request(.getSurveyByIdV2(id: data.0.survey_id))
          .filter(statusCode: 200)
          .map(MainSurveyList.self)
          .map{model in return (model, data.1)}}
     
      .subscribe(onNext: { [weak self] (data) in
        guard let model = data.0.result.data.first, let `self` = self else {return}
        self.model = model
//        self.dataSubject.value.remove(at: data.1.)
//        self.dataSources.sectionModels.first?.items.remove(at: data.
//        self.dataSources.sectionModels[0].items.remove(at: data.1.item)
        var sectionModel = self.dataSources.sectionModels
        sectionModel[0].items.remove(at: data.1.item)
        self.dataSources.setSections(sectionModel)
        
        self.collectionView.performBatchUpdates({
          self.collectionView.deleteItems(at: [data.1])
        }) { (finished) in
          self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
        //self.collectionView.reloadData()
        //                self.collectionView.reloadItemsAtIndexPaths([data.1], animationStyle: .none)
        //        self.collectionView.reloadSections([0], animationStyle: .none)
        self.updateSurvey?(self.model, self.indexPath)})
      .disposed(by: disposeBag)
    
    detailAction
      .subscribe (onNext:{[weak self] (idx) in
        guard let `self` = self else {return}
        self.navigationController?
          .pushViewController(ListDetailResultViewController(model: self.model, selectedNum: idx), animated: true)
      }).disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupViewConstraints else { return }
        var actualKeyboardHeight = keyboardVisibleHeight
        if #available(iOS 11.0, *), keyboardVisibleHeight > 0 {
          actualKeyboardHeight = actualKeyboardHeight - self.view.safeAreaInsets.bottom
        }
        
        self.messageInputBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-actualKeyboardHeight)
        }
        
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {[weak self] in
          guard let `self` = self else {return}
          self.collectionView.contentInset.bottom = actualKeyboardHeight + self.messageInputBar.bounds.size.height
          self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)
    
    RxKeyboard.instance
      .willShowVisibleHeight
      .drive(onNext:{[weak self] in
        guard let `self` = self else {return}
        self.collectionView.contentOffset.y += $0
      })
      .disposed(by:disposeBag)
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    let messageSend = messageInputBar.sendButton
      .rx
      .tap
      .flatMap { _ in
        return CheeseService.provider.request(
          .insertReply(survey_id: self.model.id,
                       parent_id: self.messageInputBar.parentId,
                       contents: self.messageInputBar.textView.textView.text))
          .mapJSON()
          .do(onSuccess: { (_) in
            Toast(text: "댓글이 작성되었습니다.", delay: 0.2, duration: 1.5).show()
          }, onError: { (error) in
            Toast(text: "댓글 작성 실패.", delay: 0.5, duration: 1.5).show()
          }).map{[weak self] _ in return self?.messageInputBar}
          .do(onSuccess: {[weak self] (bar) in
            bar?.reloadData()
          })
      }.share()
    
    messageSend
      .flatMap {[unowned self] (_)  in
        return CheeseService
          .provider
          .request(.getSurveyByIdV2(id: self.model.id))
          .map(MainSurveyList.self)
          .asObservable()
      }.subscribe(onNext: {[weak self] (model) in
        guard let `self` = self, let model = model.result.data.first else {return}
        self.model = model
        self.replyRequest()
        self.collectionView.reloadData()
        self.updateSurvey?(self.model, self.indexPath)
      }).disposed(by: disposeBag)
  }
  
  private func navigationBarSetup(){
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.hidesBarsOnSwipe = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.hidesBarsOnSwipe = true
  }
  
  private func addConstraint(){
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func replyRequest(){
    provider.request(.getReplyList(surveyId: model.id))
      .filter(statusCode: 200)
      .map(ReplyModel.self)
      .asObservable()
      .replyMapper()
      .bind(to: dataSubject)
      .disposed(by: disposeBag)
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    guard !self.didSetupViewConstraints else { return }
    self.didSetupViewConstraints = true
    
    self.messageInputBar.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      boxBottomConstraint = make.bottom.equalTo(self.bottomLayoutGuide.snp.top).constraint
    }
  }
}
extension ReplyViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = self.dataSources.sectionModels.first?.items[indexPath.item]
      .contents
      .boundingRect(with: CGSize(width: 287.0, height: UIScreen.main.bounds.height)
        ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]).height
    return CGSize(width: collectionView.frame.width, height: (height ?? 0) + 60)
  }
}
