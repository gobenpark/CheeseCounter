//
//  sample.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//



import UIKit

import DZNEmptyDataSet
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import SwiftyJSON
import Toaster
import XLPagerTabStrip
import NVActivityIndicatorView

enum PagingType{
  case premium(id: String)
  case ordinary(id: String)
}

protocol CheeseDataRequestProtocol {
  func initRequest()
}

class CheeseViewController: UIViewController, DZNEmptyDataSetDelegate, UISearchControllerDelegate, IndicatorInfoProvider, CheeseDataRequestProtocol
{
  // 검색
  let searchText = BehaviorRelay<String>(value: String())
  lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.hidesNavigationBarDuringPresentation = false
    sc.searchBar.showsCancelButton = true
    sc.searchBar.placeholder = "검색어를 입력하세요 "
    sc.obscuresBackgroundDuringPresentation = false
    sc.delegate = self
    return sc
  }()
  
  let homeButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "header_home@1x")
    button.style = .plain
    return button
  }()
  
  //MARK: - Property
  /// 검색인지
  let isSearch: Bool
  
  let disposeBag = DisposeBag()
  let cheeseDatas = Variable<[CheeseViewModel]>([])
  let buttonEvent = PublishSubject<(MainSurveyAction,MainSurveyList.CheeseData,IndexPath?)>()
  let moreEvent = PublishSubject<IndexPath>()
  let replyEvent = PublishSubject<IndexPath>()
  let empathyEvent = PublishSubject<(String, IndexPath)>()
  let shareEvent = PublishSubject<IndexPath>()
  
  lazy var updateSurvey: (MainSurveyList.CheeseData, IndexPath) -> Void = { [weak self] model, indexPath in
    guard let `self` = self else { return }
    self.cheeseDatas.value[indexPath.section].items[indexPath.item] = model
    UIView.performWithoutAnimation { [weak self] in
      guard let `self` = self else {return}
      self.collectionView.reloadItems(at: [indexPath])
    }
  }
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.model = item
    cell.cheeseVC = self
    cell.indexPath = idx
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 6.5
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 6.5, right: 0)
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    collectionView.backgroundColor = #colorLiteral(red: 0.9097241759, green: 0.9098549485, blue: 0.9096954465, alpha: 1)
    collectionView.alwaysBounceVertical = true
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
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  let refreshView: UIRefreshControl = {
    let view = UIRefreshControl()
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  //MARK: - View Life Cycle
  
  init(isSearch: Bool = false) {
    self.isSearch = isSearch
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = collectionView
    self.navigationController?.navigationBar.shadowImage = UIImage()
    
    if !isSearch{
      title = "응답"
      collectionView.addSubview(refreshView)
      //self.navigationController?.hidesBarsOnSwipe = true
    }else{
      title = "검색"
    }
  }
  
  func navigationHidden(point: CGPoint){
    if point.y > 0{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      }, completion: nil)
    }else{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      }, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ToastView.appearance().font = UIFont.CheeseFontMedium(size: 15)
    ToastView.appearance().bottomOffsetPortrait = 100
    
    
    cheeseDatas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.willEndDragging
      .map{$0.0}
      .asDriver(onErrorJustReturn: .zero)
      .drive(onNext: navigationHidden)
      .disposed(by: disposeBag)
    
    // 메인뷰 2 or 4  이벤트
    buttonEvent.observeOn(MainScheduler.instance)
      .flatMap { (data) -> Observable<(MainSurveyAction, MainSurveyList.CheeseData, IndexPath?)> in
        switch data.0{
        case .Button(let index):
          return CheeseService.provider
            .request(.insertSurveyResult(surveyId: data.1.id, select: "\(index)"))
            .asObservable()
            .filter(statusCode: 200)
            .map{ _ in
              return data
          }
        case .Image:
          return Observable<(MainSurveyAction, MainSurveyList.CheeseData,IndexPath?)>.just(data)
        }
      }
      .bind(onNext: showGiftView)
      .disposed(by: disposeBag)
    
    // 더보기 이벤트
    moreEvent.observeOn(MainScheduler.instance)
      .subscribe(onNext: {[weak self] (idx) in
        guard let `self` = self else {return}
        self.cheeseDatas.value[idx.section].items[idx.item].isExpand = true
        self.collectionView.reloadItems(at: [idx])
      }).disposed(by: disposeBag)
    
    // 공감버튼 이벤트
    empathyEvent.do(onNext: {[weak self] (data) in
      self?.cheeseDatas.value[data.1.section].items[data.1.item].is_empathy = "1"
      self?.collectionView.reloadItems(at: [data.1])
    }).flatMap {(data) in
      return CheeseService.provider
        .request(.insertEmpathy(id: data.0))
        .filter(statusCode: 200)
        .map{_ in return data}
        .asObservable()
      }.flatMap { (data) in
        CheeseService.provider
          .request(.getSurveyByIdV2(id: data.0))
          .filter(statusCode: 200)
          .map(MainSurveyList.self)
          .map{model in return (model, data.1)}
      }.subscribe(onNext: { [weak self] (data) in
        guard let `self` = self , let result = data.0.result.data.first else {return}
        self.cheeseDatas.value[data.1.section].items[data.1.item] = result
        self.collectionView.reloadItems(at: [data.1])
      }).disposed(by: disposeBag)
    
    // 댓글 버튼 이벤트
    replyEvent.map { [unowned self] (idx) in
      return (self.dataSources.sectionModels[idx.section].items[idx.item],idx)
      }.subscribe(onNext:{[weak self] (model) in
        guard let `self` = self else {return}
        if model.0.survey_result == nil{
          Toast(text: "질문에 먼저 응답해주세요", delay: 0.4, duration: 1).show()
        }else{
          self.navigationController?.pushViewController(ReplyViewController(model: model.0, indexPath: model.1, updateSurvey: self.updateSurvey), animated: true)
        }
      }).disposed(by: disposeBag)
    
    // 공유버튼 이벤트
    shareEvent.map {[unowned self] (idx) in
      return self.dataSources.sectionModels[idx.section].items[idx.item]
      }.map{[unowned self] model in return ShareController.shareActionSheet(model: model, fromViewController: self)}
      .subscribe(onNext: {[weak self] (vc) in
        guard let `self` = self else {return}
        self.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    initRequest()
    
    if isSearch{
      searchController.definesPresentationContext = true
      searchText
        .asObservable()
        .map{ text in return (String(),text)}
        .bind(onNext: searchRequest)
        .disposed(by: disposeBag)
      
      searchController.searchBar
        .rx
        .text
        .filterNil()
        .distinctUntilChanged()
        .bind(to: searchText)
        .disposed(by: disposeBag)
      
      homeButton.rx.tap
        .subscribe {[weak self] (_) in
          guard let `self` = self else {return}
          self.navigationController?.popViewController(animated: false)
        }.disposed(by: disposeBag)
      
      searchNavigationSetting()
    }else{
      refreshView.rx
        .controlEvent(.valueChanged)
        .subscribe { [weak self](event) in
          self?.cheeseDatas.value.removeAll()
          self?.initRequest()
          self?.refreshView.endRefreshing()}
        .disposed(by: disposeBag)
      navigationBarSetup()
    }
  }
  
  private func searchNavigationSetting(){
    self.definesPresentationContext = true 
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image, for: .default)
    self.navigationItem.setLeftBarButton(homeButton, animated: false)
    navigationItem.titleView = searchController.searchBar
  }
  
  private func showGiftView(data:(MainSurveyAction, MainSurveyList.CheeseData, IndexPath?)){
    
    switch data.0{
    case .Button:
      
      let giftView = GifViewController()
      giftView.imageType = .cheese
      giftView.modalPresentationStyle = .overCurrentContext
      giftView.modalTransitionStyle = .flipHorizontal
      
      giftView.dismissCompleteAction = {[weak self] in
        guard let `self` = self else {return}
        CheeseService.provider.request(.getSurveyByIdV2(id: data.1.id))
          .filter(statusCode: 200)
          .map(MainSurveyList.self)
          .subscribe(onSuccess: {[weak self] (response) in
            guard let `self` = self ,let idx = data.2,
              let data = response.result.data.first,
              let cell = self.collectionView.cellForItem(at: idx) as? MainViewCell
              else {return}
            
            cell.selectImage.removeFromSuperview()
            cell.selectImage.snp.removeConstraints()
            self.cheeseDatas.value[idx.section].items[idx.item] = data
            self.collectionView.reloadItems(at: [idx])
          }) { (error) in
            log.error(error)
          }.disposed(by: self.disposeBag)
      }
      if isSearch{
        self.searchController.present(giftView, animated: true, completion: nil)
      }else{
        self.present(giftView, animated: true, completion: nil)
      }
    case .Image(let num):
      self.navigationController?.pushViewController(ListDetailResultViewController(model: data.1, selectedNum: num), animated: true)
      log.info("model : \(data.1), selectedNum: \(num)")
    }
  }
  
  func initRequest(){
    networkRequest(reload: true)
  }
  
  func requestSurveyList(reload: Bool) -> Observable<CheeseViewModel> {
    let id = dataSources.sectionModels.last?.items.last?.id ?? ""
    if !reload {
//      let id = dataSources.sectionModels.last?.items.last?.id ?? ""
      return CheeseService.provider.request(.getSurveyListV2(id: id))
        .filter(statusCode: 200)
        .map(MainSurveyList.self)
        .map {CheeseViewModel(items: $0.result.data)}
        .asObservable()
    
    } else {
      let event = CheeseService.provider.request(.getEventSurveyList)
        .filter(statusCode: 200)
        .map(MainSurveyList.self)
        .map {CheeseViewModel(items: $0.result.data)}
        .asObservable()
      let nonEvent = CheeseService.provider.request(.getSurveyListV2(id: id))
        .filter(statusCode: 200)
        .map(MainSurveyList.self)
        .map {CheeseViewModel(items: $0.result.data)}
        .asObservable()
      return Observable<CheeseViewModel>
        .combineLatest(event, nonEvent) { (ev, nonev) -> CheeseViewModel in
          return CheeseViewModel(items: ev.items + nonev.items)
      }
    }
  }

  private func networkRequest(reload: Bool) {
    var retryCount = 3
    
    requestSurveyList(reload: reload)
      .retryWhen{ (errorObservable: Observable<Error>) in
        return errorObservable.flatMap({ (err) -> Observable<Int> in
          if retryCount > 0 {
            retryCount -= 1
            return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
          } else {
            return Observable<Int>.error(err)
          }
        })}
      .catchErrorJustReturn(CheeseViewModel(items: []))
      .filter({ (viewModel) -> Bool in
        return viewModel.items.count != 0
      })
      .scan(cheeseDatas.value){ (state: [CheeseViewModel], viewModel: CheeseViewModel) -> [CheeseViewModel] in
        if reload {
          return [viewModel]
        } else {
          return state + viewModel
        }
      }
      .bind(to: cheeseDatas)
      .disposed(by: disposeBag)
  }
  
  /// 검색용 Zzzzfsrequest
  ///
  /// - Parameter data:
  private func searchRequest(data:(String, String)){
    
    if data.0 == String(){
      self.cheeseDatas.value.removeAll()
    }
    
    CheeseService.provider.request(.getSurveyListV2Search(id: data.0, search: data.1))
      .filter(statusCode: 200)
      .map(MainSurveyList.self)
      .map {CheeseViewModel(items: $0.result.data)}
      .asObservable()
      .catchErrorJustReturn(CheeseViewModel(items: []))
      .filter({ (viewModel) -> Bool in
        return viewModel.items.count != 0
      })
      .scan(cheeseDatas.value){ (state: [CheeseViewModel], viewModel: CheeseViewModel) -> [CheeseViewModel] in
        return state + viewModel
      }.bind(to: cheeseDatas)
      .disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard isSearch else {return}
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image, for: .default)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard isSearch else {return}
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).image, for: .default)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard isSearch else {return}
    self.searchController.isActive = true
  }
  
  private func navigationBarSetup(){
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
  }
  func presentSearchController(_ searchController: UISearchController) {
    searchController.searchBar.becomeFirstResponder()
  }
  
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "최신 질문")
  }
}

extension CheeseViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sectionModel = self.dataSources.sectionModels
//    log.info(collectionView.frame.width)
    
    switch sectionModel[indexPath.section].items[indexPath.item].type{
    case "2":
      if sectionModel[indexPath.section].items[indexPath.item].isExpand{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width + 25)
      }
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 35)
    case "4":
      if sectionModel[indexPath.section].items[indexPath.item].isExpand{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width + 200)
      }
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.width + 165)
    default:
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.width - 35)
    }
  }
}

extension CheeseViewController{
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
    if didReachBottom{
      networkRequest(reload: false)
    }
  }
}

extension CheeseViewController: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = NSAttributedString(string: "모든 질문에 응답하셨거나\n\n아직 등록된 질문이 없어요.\n\n직접 질문을 등록해보세요."
      , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])

    activityView.startAnimating()
    return activityView
    
    //    if isLoading{
    //      return activityView
    //    }else {
    //      return label
    //    }
  }
  
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}


