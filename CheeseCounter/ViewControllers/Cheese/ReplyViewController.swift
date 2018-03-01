//
//  ReplyViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 6..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import Moya
import NextGrowingTextView
import Toaster

final class ReplyViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  private let provider = MoyaProvider<CheeseCounter>().rx
  private let refreshView = UIRefreshControl()
  let writeReplySubject = PublishSubject<ReplyActionData>()
  let dataSubject = Variable<[ReplyViewModel]>([])
  let messageInputBar = MessageInputBar()
  
  private var didSetupViewConstraints = false
  var model: MainSurveyList.CheeseData
  
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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ReplyHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: ReplyHeaderView.self))
    collectionView.register(ReplyViewCell.self, forCellWithReuseIdentifier: String(describing: ReplyViewCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    return collectionView
  }()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  let searchButton: UIBarButtonItem = {
    let barbutton = UIBarButtonItem()
    barbutton.image = #imageLiteral(resourceName: "header_search@1x").withRenderingMode(.alwaysTemplate)
    barbutton.style = .plain
    return barbutton
  }()
  
  init(model: MainSurveyList.CheeseData) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.addSubview(refreshView)
    view.addSubview(messageInputBar)
    
    navigationBarSetup()
    addConstraint()
    replyRequest()
    
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
    
    collectionView.rx.didScroll
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: {[weak self] (_) in
        guard let `self` = self else {return}
        self.messageInputBar.textView.endEditing(true)
      }).disposed(by: disposeBag)
    
    writeReplySubject
      .asDriver(onErrorJustReturn: ReplyActionData(nickname: String(), parentID: String()))
      .do(onNext: {[weak self] (_) in
        self?.messageInputBar.textView.textView.becomeFirstResponder()
      })
      .drive(onNext: {[weak self] data in
        guard let `self` = self else {return}
        self.messageInputBar.replyType = .ReReply(replyData: data)
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
        UIView.animate(withDuration: 0) {
          self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.bounds.size.height
          self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)
    
    searchButton
      .rx
      .tap.subscribe {[weak self] (_) in
        self?.navigationController?.pushViewController(SearchListViewController(type: .main), animated: false)
      }.disposed(by: disposeBag)
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    messageInputBar.sendButton
      .rx
      .tap
      .bind(onNext: insertRequest)
      .disposed(by: disposeBag)
  }
  
  private func insertRequest(){
    ToastView.appearance().bottomOffsetPortrait = 200
    provider.request(
      .insertReply(survey_id: self.model.id,
                   parent_id: self.messageInputBar.parentId,
                   contents: self.messageInputBar.textView.textView.text))
      .mapJSON()
      .do(onNext: { (_) in
        Toast(text: "댓글이 작성되었습니다.", delay: 0.2, duration: 1.5).show()
      }, onError: { (error) in
        Toast(text: "댓글 작성 실패.", delay: 0.5, duration: 1.5).show()
      })
      .map{[weak self] _ in return self?.messageInputBar}
      .subscribe(onSuccess: {[weak self] (view) in
        view?.textView.textView.text = String()
        view?.textView.textView.resignFirstResponder()
        view?.replyType = .Reply
        self?.replyRequest()
      }, onError: { (error) in
        log.error(error)
      })
      .disposed(by: disposeBag)
    
  }
  private func navigationBarSetup(){
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.hidesBarsOnSwipe = false
//    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    self.navigationController?.hidesBarsOnSwipe = true
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
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
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
