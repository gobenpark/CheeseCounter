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

enum PagingType{
  case premium(id: String)
  case ordinary(id: String)
}

final class CheeseViewController: UIViewController, DZNEmptyDataSetDelegate
{
  
  //MARK: - Property
  private let disposeBag = DisposeBag()
  private let provider = MoyaProvider<CheeseCounter>().rx
  
  let cheeseDatas = Variable<[CheeseViewModel]>([])
  let buttonEvent = PublishSubject<(MainSurveyAction,MainSurveyList.CheeseData)>()
  let moreEvent = PublishSubject<IndexPath>()
  let replyEvent = PublishSubject<IndexPath>()
  let emptyEvent = PublishSubject<String>()
  let shareEvent = PublishSubject<IndexPath>()

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
  
  override func loadView() {
    super.loadView()
    view = collectionView
    collectionView.addSubview(refreshView)
    title = "응답"
    self.navigationController?.hidesBarsOnSwipe = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    cheeseDatas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    refreshView.rx
      .controlEvent(.valueChanged)
      .subscribe { [weak self](event) in
        self?.cheeseDatas.value.removeAll()
        self?.networkRequest(id: String())
        self?.refreshView.endRefreshing()}
      .disposed(by: disposeBag)
    
    buttonEvent.observeOn(MainScheduler.instance)
      .flatMap { [unowned self] (data) -> Observable<(MainSurveyAction, MainSurveyList.CheeseData)> in
        switch data.0{
        case .Button(let index):
          return self.provider
            .request(.insertSurveyResult(surveyId: data.1.id, select: "\(index)"))
            .asObservable()
            .filter(statusCode: 200)
            .debug()
            .map{ _ in
              return data
          }
        case .Image:
          return Observable<(MainSurveyAction, MainSurveyList.CheeseData)>.just(data)
        }
      }
      .bind(onNext: showGiftView)
      .disposed(by: disposeBag)
    
    moreEvent.observeOn(MainScheduler.instance)
      .subscribe(onNext: {[weak self] (idx) in
        guard let `self` = self else {return}
        self.cheeseDatas.value[idx.section].items[idx.item].isExpand = true
        self.collectionView.reloadData()
      }).disposed(by: disposeBag)
    
    emptyEvent.flatMap {[unowned self] (id) in
      return self.provider.request(.insertEmpathy(id: id))
        .filter(statusCode: 200)
        .asObservable()
      }.subscribe(onNext: { (response) in
        log.info(response)
      }, onError: { (error) in
        log.error(error)
      }).disposed(by: disposeBag)
    
    replyEvent.map { [unowned self] (idx) in
      return self.dataSources.sectionModels[idx.section].items[idx.item]
      }.subscribe(onNext:{[weak self] (model) in
        guard let `self` = self else {return}
        self.navigationController?.pushViewController(ReplyViewController(model: model), animated: true)
      }).disposed(by: disposeBag)
    
    shareEvent.map {[unowned self] (idx) in
      return self.dataSources.sectionModels[idx.section].items[idx.item]
      }.map{[unowned self] model in return ShareController.shareActionSheet(model: model, fromViewController: self)}
      .subscribe(onNext: {[weak self] (vc) in
        guard let `self` = self else {return}
        self.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    searchButton.rx
      .tap.subscribe {[weak self] (_) in
        self?.navigationController?.pushViewController(SearchListViewController(type: .main), animated: false)
      }.disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    
//    definesPresentationContext = true //중요
    
    networkRequest(id: String())
    navigationBarSetup()
  }
  
  private func showGiftView(data:(MainSurveyAction, MainSurveyList.CheeseData)){
    
    switch data.0{
    case .Button(let num):
      let giftView = GifViewController()
      giftView.imageType = .cheese
      giftView.modalPresentationStyle = .overCurrentContext
      giftView.modalTransitionStyle = .flipHorizontal
      
      giftView.dismissCompleteAction = {[weak self] in
        guard let retainSelf = self else {return}
        
        retainSelf.navigationController?.pushViewController(ListDetailResultViewController(model: data.1, selectedNum: num), animated: true)
      }
      self.present(giftView, animated: true, completion: nil)
    case .Image(let num):
      self.navigationController?.pushViewController(ListDetailResultViewController(model: data.1, selectedNum: num), animated: true)
    }
  }
  
  private func networkRequest(id: String){
    
    provider.request(.getSurveyListV2(id: id))
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
  
  private func navigationBarSetup(){
    
    let titleLabel = UILabel()
    titleLabel.text = "응답"
    titleLabel.font = UIFont.CheeseFontBold(size: 17)
    titleLabel.sizeToFit()
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
    self.navigationItem.titleView = titleLabel
  }
}

extension CheeseViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let sectionModel = self.dataSources.sectionModels
    
    switch sectionModel[indexPath.section].items[indexPath.item].type{
    case "2":
      if sectionModel[indexPath.section].items[indexPath.item].isExpand{
        return CGSize(width: collectionView.frame.width, height: 400)
      }
      return CGSize(width: collectionView.frame.width, height: 340)
    case "4":
      if sectionModel[indexPath.section].items[indexPath.item].isExpand{
        return CGSize(width: collectionView.frame.width, height: 570)
      }
      return CGSize(width: collectionView.frame.width, height: 520)
    default:
      return CGSize(width: collectionView.frame.width, height: 340)
    }
  }
}

extension CheeseViewController{
    
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
     if didReachBottom{
      networkRequest(id: dataSources.sectionModels.last?.items.last?.id ?? "")
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


