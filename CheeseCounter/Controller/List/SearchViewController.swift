//
//  SearchViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class SearchViewController: UIViewController{
  
  var isLoading: Bool = false
  var nextPageNumber: Int = 1
  var searchString: String = ""
  
  var cheeseData: [CheeseResultByDate.Data]?{
    didSet{
      self.collectionView.reloadData()
    }
  }
  
  lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.hidesNavigationBarDuringPresentation = false
    sc.dimsBackgroundDuringPresentation = false
    sc.searchBar.showsCancelButton = true
    sc.delegate = self
    sc.searchBar.placeholder = "검색어를 입력하세요 "
    sc.searchBar.delegate = self
    return sc
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.register(BaseListCell.self, forCellWithReuseIdentifier: String(describing: BaseListCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.definesPresentationContext = true
    
    self.view = collectionView
    let navigationBarBackGroundImage =  UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image
    self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackGroundImage, for: .default)
    self.navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "header_home@1x"), style: .plain, target: self, action: #selector(dismissAction)), animated: true)
    self.navigationItem.titleView = searchController.searchBar
  }
  
  func searchData(search: String, paging: Paging){
    log.info(paging)
    guard !self.isLoading else {return}
    self.isLoading = true
    CheeseService.getSearchSurveyList(search: search, paging: paging) { (response) in
      self.isLoading = false
      switch response.result{
      case .success(let value):
        let newData = value.data ?? []
        switch paging{
        case .refresh:
          self.cheeseData = newData
          self.nextPageNumber = 1
        case .next:
          guard !newData.isEmpty else {return}
          self.cheeseData?.append(contentsOf: newData)
        }
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  func dismissAction(){
    self.dismiss(animated: false, completion: nil)
  }
}

extension SearchViewController: UISearchBarDelegate{
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let searchString = searchBar.text else {return}
    self.searchData(search: searchString, paging: .refresh)
    self.searchString = searchString
  }
}

extension SearchViewController: UISearchControllerDelegate{
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 100)
  }
}

extension SearchViewController: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cheeseSelectVC = CheeseSelectedViewController()
    guard let data = self.cheeseData?[indexPath.item] else {return}
    cheeseSelectVC.cheeseData = data
//    cheeseSelectVC.openType = .search
    self.navigationController?.pushViewController(cheeseSelectVC, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 100
    if didReachBottom {
      self.searchData(search: searchString, paging: .refresh)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForFooterInSection section: Int) -> CGSize {
    
    let height: CGFloat = (self.isLoading) ? 44 : 0
    return CGSize(width: collectionView.width, height: height)
  }
}

extension SearchViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count = self.cheeseData?.count else {return 0}
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BaseListCell.self), for: indexPath) as! BaseListCell
    guard let cheesedata = self.cheeseData?[indexPath.item] else {return cell}
    cell.dataUpdate(data: cheesedata)
    return cell
  }
}

extension SearchViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "검색해 주세요~", attributes: [NSFontAttributeName:UIFont.CheeseFontMedium(size: 15)])
  }
}

extension SearchViewController: DZNEmptyDataSetDelegate{
  
}

