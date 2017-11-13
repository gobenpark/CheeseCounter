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
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class SearchListViewController: UIViewController{
  
  var isLoading: Bool = false
  var nextPageNumber: Int = 1
  
  var searchType: SearchType
  let disposeBag = DisposeBag()
  let dataSource = RxCollectionViewSectionedReloadDataSource<SearchViewModel>(configureCell: { ds, cv, ip, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: BaseListCell.self), for: ip) as! BaseListCell
    cell.data = item
    return cell
  }
)
  let cellViewModels = Variable<[SearchViewModel]>([])
  
  lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.hidesNavigationBarDuringPresentation = false
    sc.dimsBackgroundDuringPresentation = false
    sc.searchBar.showsCancelButton = true
    sc.searchBar.placeholder = "검색어를 입력하세요 "
    return sc
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.register(BaseListCell.self, forCellWithReuseIdentifier: String(describing: BaseListCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
    return collectionView
  }()
  
  init(type: SearchType) {
    self.searchType = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = nil
    
    self.view = collectionView
    
    configure()
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    self.definesPresentationContext = true
    
    cellViewModels.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    switch searchType {
    case .main:
      searchController.searchBar
        .rx
        .text
        .flatMap { text -> Observable<[SearchViewModel]> in
          return CheeseService.provider.rx
            .request(.getSearchSurveyList(search: text ?? "", page_num: 0))
            .asObservable()
            .map(CheeseResultByDate.self)
            .map({ data in
              return [SearchViewModel(items: data.data!)]
            })
        }.bind(to: self.cellViewModels)
        .disposed(by: disposeBag)
    case .list:
      searchController.searchBar
        .rx
        .text
        .flatMap { text -> Observable<[SearchViewModel]> in
          return CheeseService.provider.rx
            .request(.getMySearchSurveyList(search: text ?? "", page_num: 0))
            .asObservable()
            .map(CheeseResultByDate.self)
            .map({ data in
              return [SearchViewModel(items: data.data!)]
            })
        }.bind(to: self.cellViewModels)
        .disposed(by: disposeBag)
    }
    
    
    let navigationBarBackGroundImage =  UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image
    self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackGroundImage, for: .default)
    self.navigationItem.setLeftBarButton(
      UIBarButtonItem(
      image: #imageLiteral(resourceName: "header_home@1x"), style: .plain, target: self, action: #selector(dismissAction)
    ), animated: true
    )
    self.navigationItem.titleView = searchController.searchBar
  }

  @objc func dismissAction(){
    self.dismiss(animated: false, completion: nil)
  }
  
  private func configure(){
    dataSource.configureCell = { ds, cv, ip, item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: BaseListCell.self), for: ip) as! BaseListCell
      cell.data = item
      return cell
    }
  }
}

extension SearchListViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 100)
  }
}

extension SearchListViewController: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? BaseListCell else {return}
    
    let cheeseResultVC = CheeseResultViewController()
    cheeseResultVC.cheeseData = cell.data
    self.navigationController?.pushViewController(cheeseResultVC, animated: true)
  }
  
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

    let height: CGFloat = (self.isLoading) ? 44 : 0
    return CGSize(width: collectionView.frame.width, height: height)
  }
}


extension SearchListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "검색해 주세요~", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)])
  }
}



