//
//  ListSearchViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import DZNEmptyDataSet
import SwiftyImage

final class ListSearchViewController: UIViewController{
  
  let provider = MoyaProvider<CheeseCounter>().rx
  private let cheeseDatas = Variable<[CheeseViewModel]>([])
  private let searchText = Variable<String>(String())
  private let disposeBag = DisposeBag()
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: { ds, cv, idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: SearchViewCell.self), for: idx) as! SearchViewCell
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
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.emptyDataSetSource = self
    collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: String(describing: SearchViewCell.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  private let homeButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "header_home@1x")
    button.style = .plain
    return button
  }()
  
  override func loadView() {
    super.loadView()
    view = collectionView
    self.automaticallyAdjustsScrollViewInsets = false
    definesPresentationContext = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationSetting()
    
    cheeseDatas.asDriver()
      .debug()
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
    
    searchController.searchBar
      .rx
      .text
      .filterNil()
      .distinctUntilChanged()
      .bind(to: searchText)
      .disposed(by: disposeBag)
    
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationSetting()
  }
  
  private func navigationSetting(){
    self.definesPresentationContext = true
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image, for: .default)
    self.navigationItem.setLeftBarButton(homeButton, animated: false)
    navigationItem.titleView = searchController.searchBar
  }
}

extension ListSearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "검색해 주세요~", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)])
  }
}
