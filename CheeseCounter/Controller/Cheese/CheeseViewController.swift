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

class CheeseViewController: UIViewController, DZNEmptyDataSetDelegate
{
  
  //MARK: - Property
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<CheeseCounter>().rx
  let cheeseDatas = BehaviorSubject<[CheeseViewModel]>(value: [])
  let cellSubject = PublishSubject<(Int, MainSurveyList.CheeseData)>()
  let moreEvent = PublishSubject<Int>()
  var moreDict: [Int: Bool] = [:]
  
  let gifVC: GifViewController = {
    let vc = GifViewController()
    vc.imageType = .cheese
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .flipHorizontal
    return vc
  }()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.model = item
    cell.indexPath = idx
    cell.clickEvent = self?.cellSubject
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 6.5
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view = collectionView
    collectionView.addSubview(refreshView)
    self.navigationController?.hidesBarsOnSwipe = true
    
    cheeseDatas.asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    myPageButton.rx.tap
      .subscribe { (event) in
        log.info(event)}
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    refreshView.rx.controlEvent(.valueChanged)
      .subscribe { [weak self](event) in
        self?.networkRequest()
        self?.refreshView.endRefreshing()}
      .disposed(by: disposeBag)
    
    cellSubject.subscribe {[unowned self] (event) in
      
//      gifVC.dismissCompleteAction = {
//        self?.navigationController?.pushViewController(cheeseResultVC, animated: true)
//      }
      UIApplication.shared.keyWindow?.rootViewController?.present(self.gifVC, animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    
    moreEvent.subscribe { (event) in
      log.info(event)
    }.disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    definesPresentationContext = true //중요
    
    networkRequest()
    navigationBarSetup()
  }
  
  private func networkRequest(){
    provider.request(.getSurveyList)
      .filter(statusCode: 200)
      .map(MainSurveyList.self)
      .map {[CheeseViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: cheeseDatas)
      .disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    networkRequest()
  }
  
  private func navigationBarSetup(){
    
    let titleLabel = UILabel()
    titleLabel.text = "응답"
    titleLabel.font = UIFont.CheeseFontBold(size: 17)
    titleLabel.sizeToFit()
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
    self.navigationItem.titleView = titleLabel
  }
  
  @objc private dynamic func searchViewPresent(){
    let searchView = UINavigationController(rootViewController: SearchListViewController(type: .main))
    searchView.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(searchView, animated: false, completion: nil)
  }
}

extension CheeseViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {

    switch self.dataSources.sectionModels.first?.items[indexPath.item].type{
    case "2"?:
      if moreDict[indexPath.item,default:false]{
        return CGSize(width: collectionView.frame.width, height: 370)
      }
      return CGSize(width: collectionView.frame.width, height: 340)
    case "4"?:
      if moreDict[indexPath.item,default:false]{
        return CGSize(width: collectionView.frame.width, height: 570)
      }
      return CGSize(width: collectionView.frame.width, height: 520)
    default:
      return CGSize(width: collectionView.frame.width, height: 340)
    }
  }
}

//extension CheeseViewController: UICollectionViewDelegate{
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let cell = collectionView.cellForItem(at: indexPath) as! MainViewCell
//    cell.title.reloadInputViews()
//    moreDict[indexPath.item] = true
//    UIView.performWithoutAnimation { [weak self] in
//      self?.collectionView.reloadItems(at: [indexPath])
//    }
//  }
//}

//extension CheeseViewController: DZNEmptyDataSetSource{
//
//  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
//    let label = UILabel()
//    label.textAlignment = .center
//    label.numberOfLines = 0
//    label.attributedText = NSAttributedString(string: "모든 질문에 응답하셨거나\n\n아직 등록된 질문이 없어요.\n\n직접 질문을 등록해보세요."
//      , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)
//        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
//
//    activityView.startAnimating()
//
//    if isLoading{
//      return activityView
//    }else {
//      return label
//    }
//  }
//
//  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
//  }
//}
//
//
