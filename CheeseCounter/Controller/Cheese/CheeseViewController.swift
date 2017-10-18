//
//  sample.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import Hero

enum PagingType{
  case premium(id: String)
  case ordinary(id: String)
}

class CheeseViewController: UITableViewController, DZNEmptyDataSetDelegate
{
  //MARK: - Property
  
  var storedOffsets = [Int: CGFloat]()
  var isLoading:Bool = false{
    didSet{
      log.info(isLoading)
      self.tableView.reloadEmptyDataSet()
    }
  }
  fileprivate var isPageLoading: Bool = false
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame 
      = UIScreen.main.bounds
    return view
  }()
  
  let dateString : String = {
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: today)
  }()
  
  let refreshView: UIRefreshControl = {
    let view = UIRefreshControl()
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  
  //MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tableView.separatorStyle = .none
    tableView.emptyDataSetDelegate = self
    tableView.emptyDataSetSource = self
    tableView.alwaysBounceVertical = true
    tableView.register(CheeseViewCell.self, forCellReuseIdentifier: String(describing: CheeseViewCell.self))
    tableView.backgroundColor = UIColor.cheeseColor()
    tableView.indicatorStyle = .white
    definesPresentationContext = true //중요
    self.refreshControl = refreshView
    
    let barbutton = UIBarButtonItem(image: #imageLiteral(resourceName: "header_search@1x").withRenderingMode(.alwaysTemplate),
                                    style: .plain,
                                    target: self,
                                    action: #selector(searchViewPresent))
    barbutton.tintColor = .black
    self.navigationItem.setRightBarButton(barbutton, animated: true)
    
    self.refreshView.addTarget(self,
                                  action: #selector(self.refreshControlDidChangeValue),
                                  for: .valueChanged)
    downLoadAllData()
    navigationBarSetup()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(downLoadAllData),
                                           name: NSNotification.Name(rawValue: "mainfetch"),
                                           object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if MainCheeseData.shared.mainData.isEmpty{
      downLoadAllData()
    }
  }
  
  //MARK: - Push SelectViewController Action
  
  func pushSelectedViewController(data: CheeseResultByDate.Data,tag: Int, row: Int){
    
    let cheeseSelectedViewController = CheeseSelectedViewController()
    cheeseSelectedViewController.cheeseData = data
    cheeseSelectedViewController.didTap = {[weak self] (_) in
      self?.lastSelectFixOffset(tag: tag, row: row)
    }

    self.navigationController?.pushViewController(cheeseSelectedViewController, animated: true)
  }
 
  fileprivate dynamic func refreshControlDidChangeValue(){
    self.isPageLoading = false
    downLoadAllData()
  }
  
  private func navigationBarSetup(){
    
    let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    titleButton.setTitle("응답", for: .normal)
    titleButton.setImage(#imageLiteral(resourceName: "icon_gold@1x"), for: .normal)
    titleButton.addTarget(self, action: #selector(presentCoachView), for: .touchUpInside)
    titleButton.titleLabel?.font = UIFont.CheeseFontBold(size: 17)
    titleButton.semanticContentAttribute = .forceRightToLeft
    titleButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 10, bottom: 0, right: 0)
    titleButton.setTitleColor(.black, for: .normal)
    self.navigationItem.titleView = titleButton
  }
  
  func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[0]
    self.present(coachView, animated: true, completion: nil)
  }
  
  private dynamic func searchViewPresent(){
    let searchView = UINavigationController(rootViewController: SearchListViewController(type: .main))
    searchView.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(searchView, animated: false, completion: nil)
  }
  
  private func lastSelectFixOffset(tag:Int, row: Int){
    MainCheeseData.shared.mainData[tag].data?.remove(at: row)
    guard let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? CheeseViewCell else {return}
    cell.carouselView.deleteItems(at: [IndexPath(item: row, section: 0)])
    
    if (MainCheeseData.shared.mainData[tag].data ?? []).isEmpty {
      MainCheeseData.shared.mainData.remove(at: tag)
      self.tableView.reloadData()
    }
  }
  
  //MARK: Networking Services
  
  fileprivate dynamic func downLoadAllData(){
    isLoading = true
    CheeseService.mainList { [weak self] (response) in
      guard let `self` = self else {return}
      switch response.result {
      case .success(let value):
        MainCheeseData.shared.premiumSetting(value: value)
      case .failure(let error):
        log.error(error.localizedDescription)
      }
      self.isLoading = false
      DispatchQueue.main.async {
        self.refreshView.endRefreshing()
        self.tableView.reloadData()
      }
    }
  }
  
  fileprivate func pagingFetch(pagingType: PagingType, reloadIndex: Int){
    guard !self.isPageLoading else {return}
    self.isPageLoading = true
    
    switch pagingType {
    case .ordinary(let id):
      
      let date = MainCheeseData.shared.mainData[reloadIndex].dateType.date
      
      let parameter:[String:String] = ["page_num":"\(id)","created_date":date]
      
      CheeseService.getSurveyListByDate(parameter: parameter) { [weak self](response) in
        guard let `self` = self else {return}
        switch response.result{
        case .success(let value):
          if (value.data?.isEmpty ?? true){
            return
          }else {
            self.isPageLoading = false
          }
          guard let datas = value.data else {return}
          MainCheeseData.shared.mainData[reloadIndex].data?.append(contentsOf: datas)
          
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
      }
      
    case .premium(let id):
      
      CheeseService.getSurveyListByOption(page_num: "\(id)") { [weak self](response) in
        guard let `self` = self else {return}
        switch response.result{
        case .success(let value):
          if (value.data?.isEmpty ?? true){
            return
          }else {
            self.isPageLoading = false
          }
          guard let datas = value.data else {return}
          MainCheeseData.shared.mainData[reloadIndex].data?.append(contentsOf: datas)
          DispatchQueue.main.async {
            self.tableView.reloadData()

          }
        case .failure(let error):
          log.error(error.localizedDescription)
        }
      }
    }
  }
}

//MARK: - CollectionView Delegate & DataSource

extension CheeseViewController{
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MainCheeseData.shared.mainData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheeseViewCell.self), for: indexPath) as! CheeseViewCell
    cell.setCarouselViewDataSourceDelegate(self, forRow: indexPath.item)
    return cell
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? CheeseViewCell else { return }
    tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? CheeseViewCell else { return }
    storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.current.model == "iPad"{
      return tableView.frame.height + 100
    }else{
      return UIScreen.main.bounds.height - 150
    }
  }
}

extension CheeseViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    guard let datas = MainCheeseData.shared.mainData[collectionView.tag].data else {return}
    if !datas.isEmpty{
      self.pushSelectedViewController(data: datas[indexPath.item], tag: collectionView.tag, row: indexPath.item)
    }
  }
}

extension CheeseViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MainCheeseData.shared.mainData[collectionView.tag].data?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let dataType = MainCheeseData.shared.mainData[collectionView.tag].data?[indexPath.item].type else {return UICollectionViewCell()}
  
    if dataType == "2"{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarouselCell2.self), for: indexPath) as! CarouselCell2
      cell.data = MainCheeseData.shared.mainData[collectionView.tag].data?[indexPath.item]
      return cell
    }else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarouselCell4.self), for: indexPath) as! CarouselCell4
      cell.data = MainCheeseData.shared.mainData[collectionView.tag].data?[indexPath.item]
      return cell
    }
  }
 
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView != self.tableView {
      let contentOffsetRight = scrollView.contentOffset.x + scrollView.width
      let didReachRight = scrollView.contentSize.width > 0
        && contentOffsetRight >= scrollView.contentSize.width
      
      if didReachRight{
        
        guard let option = MainCheeseData.shared.mainData[scrollView.tag].data?.last?.is_option else {return}
        let id = MainCheeseData.shared.mainData[scrollView.tag].data?.last?.id ?? ""
        log.info(id)
        if option == "1"{
          self.pagingFetch(pagingType: .premium(id: id), reloadIndex: scrollView.tag)
        }else {
          self.pagingFetch(pagingType: .ordinary(id: id), reloadIndex: scrollView.tag)
        }
      }
    }
  }
}


//MARK: - CollectionViewFlowLayoutDelegate

extension CheeseViewController: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = NSAttributedString(string: "모든 질문에 응답하셨거나\n\n아직 등록된 질문이 없어요.\n\n직접 질문을 등록해보세요."
      , attributes: [NSFontAttributeName:UIFont.CheeseFontMedium(size: 15)
        ,NSForegroundColorAttributeName:UIColor.gray])
    
    activityView.startAnimating()
    
    if isLoading{
      return activityView
    }else {
      return label
    }
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}


