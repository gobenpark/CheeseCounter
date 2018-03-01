//
//  SearchViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

enum SearchType{
  case main
  case list
}

import DZNEmptyDataSet
import SwiftyImage
import Moya
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class SearchListViewController: UIViewController{
  
  var searchType: SearchType
  let disposeBag = DisposeBag()
  let searchText = Variable<String>(String())
  private let provider = MoyaProvider<CheeseCounter>().rx
  let cheeseDatas = Variable<[CheeseViewModel]>([])
  let dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: { ds, cv, idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.model = item
    return cell
  }
)
  
  lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.hidesNavigationBarDuringPresentation = false
    sc.searchBar.showsCancelButton = true
    sc.searchBar.placeholder = "검색어를 입력하세요 "
    sc.obscuresBackgroundDuringPresentation = false
    return sc
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.backgroundColor = #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
    return collectionView
  }()
  
  private let homeButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "header_home@1x")
    button.style = .plain
    return button
  }()
  
  override func loadView() {
    view = collectionView
  }
  
  init(type: SearchType) {
    self.searchType = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationSetting()
    definesPresentationContext = true
    cheeseDatas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    homeButton.rx.tap
      .subscribe {[weak self] (_) in
        guard let `self` = self else {return}
        self.navigationController?.popViewController(animated: false)
    }.disposed(by: disposeBag)
    
    searchText
      .asObservable()
      .map{ text in return (String(),text)}
      .bind(onNext: request)
      .disposed(by: disposeBag)
    
    switch searchType {
    case .main:
      searchController.searchBar
        .rx
        .text
        .filterNil()
        .distinctUntilChanged()
        .bind(to: searchText)
        .disposed(by: disposeBag)
      
    case .list:
      searchController.searchBar
        .rx
        .text
        .subscribe({ (event) in
          log.info(event)
        }).disposed(by:disposeBag)
    }
  }
  
  private func request(data:(String, String)){
    
    if data.0 == String(){
      self.cheeseDatas.value.removeAll()
    }
    
    provider.request(.getSurveyListV2Search(id: data.0, search: data.1))
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
  
  private func navigationSetting(){
    self.definesPresentationContext = true
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image, for: .default)
    self.navigationItem.setLeftBarButton(homeButton, animated: false)
    navigationItem.titleView = searchController.searchBar
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).image, for: .default)
  }
}

extension SearchListViewController: UICollectionViewDelegateFlowLayout{
  
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

extension SearchListViewController: UICollectionViewDelegate{
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 100
    if didReachBottom {
    }
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForFooterInSection section: Int) -> CGSize {

//    let height: CGFloat = (self.isLoading) ? 44 : 0
    return CGSize(width: collectionView.frame.width, height: 44)
  }
}


extension SearchListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "검색해 주세요~", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)])
  }
}



