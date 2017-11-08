//
//  DetailResultViewController2.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import Charts
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

enum foldStateType{
  case fold
  case expand
}

enum reloadStateType{
  case barchart
  case all
  case circleChart
  case circlebar
}

class ListDetailResultViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  var mainData:DetailResult?
  var totalCount:Int = 0
  var parameter:[String:String] = [:]
  
  var selectAsk: Int?
  var surveyId: String?
  
  var surveyDetailResultData: DetailResult.Data?
  var cheeseData: CheeseResult?{
    didSet{
      self.collectionView.reloadData()
    }
  }
  
  var foldState: foldStateType = .fold{
    didSet{
      UIView.animate(withDuration: 0.5) {
        self.collectionView.reloadSections(IndexSet(integer: 0))
      }
    }
  }
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.register(ListDetailHeaderViewCell.self
      , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: ListDetailHeaderViewCell.self))
    
    collectionView.register(ListDetailFooterView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: String(describing: ListDetailFooterView.self))
    
    collectionView.register(ListDetailTitleCell.self, forCellWithReuseIdentifier: String(describing: ListDetailTitleCell.self))
    collectionView.register(ListDetailGraphViewCell.self
      , forCellWithReuseIdentifier: String(describing: ListDetailGraphViewCell.self))
    collectionView.register(CircleChartView.self, forCellWithReuseIdentifier: String(describing: CircleChartView.self))
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608381391, blue: 0.9606701732, alpha: 1)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "상세결과보기"
    
    self.view = collectionView
    

    guard let ask = selectAsk , let surveyID = surveyId else {return}
    CheeseService.provider.rx
      .request(.getDetailResult(parameter: ["survey_id":surveyID,"select_ask":"\(ask)","addr":""]))
      .asObservable()
      .map(DetailResult.self)
      .subscribe { (event) in
        log.info(event)
    }.disposed(by: disposeBag)
    
    
    self.fetch(selectAsk: "\(ask)", survey_id: surveyID, reloadType: .all)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9905284047, green: 0.8955592513, blue: 0.2977691889, alpha: 1), height: 2)
  }
  
  func fetch(selectAsk:String,survey_id:String, addr:String = "", reloadType: reloadStateType = .all){
    
    parameter = ["survey_id":survey_id,"select_ask":selectAsk,"addr":addr]
    
    CheeseService.getDetailResult(parameter: parameter) {[weak self] (response) in
      switch response.result{
      case .success(let value):
        self?.mainData = value
      case .failure(let error):
        log.error(error.localizedDescription)
      }
      
      switch reloadType{
      case .all:
        self?.collectionView.reloadData()
      case .barchart:
        self?.collectionView.reloadItems(at: [IndexPath(item: 1, section: 1)])
      case .circlebar:
        self?.collectionView.reloadSections(IndexSet(integer: 1))
      case .circleChart:
        self?.collectionView.reloadItems(at: [IndexPath(item: 0, section: 1),IndexPath(item: 1, section: 1)])
      }
    }
  }
 
  // 순서대로 소팅
  fileprivate func calculateRank() -> [SurveyResult.Data]?{
    
    let sortedData = cheeseData?.resultData?.sorted(by: { (data, data1) -> Bool in
      let data1Count = Int(data.count ?? "0") ?? 0
      let data2Count = Int(data1.count ?? "0") ?? 0
      return data1Count > data2Count
    })
    return sortedData
  }
  
  /// 폴딩효과를 위한 enum 세팅
  fileprivate dynamic func foldingAction(_ sender: UIButton){
    
    if foldState == .expand{
      foldState = .fold
      sender.isSelected = true
    }else {
      foldState = .expand
      sender.isSelected = false
    }
  }
  
  ///선택셀 1 또는 2지선자 4지선다 셀반환
  fileprivate func selectItemCell(cell: ListDetailTitleCell, selectAsk: String?) -> ListDetailTitleCell{
    
    guard let ask = Int(selectAsk ?? "0") else {return cell}
    switch ask {
    case 1:
      cell.titleLabel.text = self.cheeseData?.cheeseData.ask1
    case 2:
      cell.titleLabel.text = self.cheeseData?.cheeseData.ask2
    case 3:
      cell.titleLabel.text = self.cheeseData?.cheeseData.ask3
    case 4:
      cell.titleLabel.text = self.cheeseData?.cheeseData.ask4
    default:
      break
    }
    
    cell.countLabel.text = calculateRank()?.filter({ (data) -> Bool in
      if data.select_ask == "\(ask)"{
        return true
      }else {
        return false
      }
    }).first?.count ?? "0"
    return cell
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

//MARK: - DataSource

extension ListDetailResultViewController: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0{
      switch foldState {
      case .fold:
        return 1
      case .expand:
        return Int(cheeseData?.cheeseData.type ?? "0") ?? 0
      }
    }else {
      return 2
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0{
      return CGSize(width: collectionView.frame.width, height: 50)
    }else{
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 0 {
      return CGSize(width: collectionView.frame.width, height: 30)
    }else {
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    if kind == UICollectionElementKindSectionHeader && indexPath.section == 0{
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionElementKindSectionHeader,
        withReuseIdentifier: String(describing: ListDetailHeaderViewCell.self),
        for: indexPath) as! ListDetailHeaderViewCell
      view.titleLabel.text = cheeseData?.cheeseData.title ?? ""
      return view
    }else if kind == UICollectionElementKindSectionFooter && indexPath.section == 0 {
        let view = collectionView.dequeueReusableSupplementaryView(
          ofKind: UICollectionElementKindSectionFooter,
          withReuseIdentifier: String(describing: ListDetailFooterView.self),
          for: indexPath) as! ListDetailFooterView
      view.foldButton.addTarget(self, action: #selector(foldingAction(_:)), for: .touchUpInside)
      return view
    }
    return UICollectionReusableView()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0{
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListDetailTitleCell.self), for: indexPath) as! ListDetailTitleCell
      cell.tag = indexPath.item + 1
      switch foldState{
      case .expand:
        guard let count = calculateRank()?.count else {return cell}
        if count != indexPath.item && indexPath.item < count{
          return selectItemCell(cell: cell, selectAsk: calculateRank()?[indexPath.item].select_ask)
        }else {
          return selectItemCell(cell: cell, selectAsk: "\(indexPath.item + 1)")
        }
      case .fold:
        return selectItemCell(cell: cell, selectAsk: mainData?.select_ask)
      }
      
    }else {
      
      switch indexPath.item{
      case 0:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CircleChartView.self)
          , for: indexPath) as! CircleChartView
        cell.dataFetch(datas: self.mainData?.data)
        cell.didTap = {[weak self] (country) in
          let selectAsk = self?.parameter["select_ask"] ?? ""
          let survey_id = self?.parameter["survey_id"] ?? ""
          self?.fetch(selectAsk: selectAsk, survey_id: survey_id, addr: country, reloadType: .barchart)
        }
        cell.didNotTap = {[weak self] _ in
          guard let ask = self?.selectAsk , let surveyID = self?.surveyId else {return}
          self?.fetch(selectAsk: "\(ask)", survey_id: surveyID, reloadType: .all)
        }
        return cell
      case 1:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListDetailGraphViewCell.self)
          , for: indexPath) as! ListDetailGraphViewCell
        guard let data = self.mainData else {return cell}
        cell.updateData(data: data.data)
        return cell
      default:
        break
      }
    }
    return UICollectionViewCell()
  }
}

//MARK: - Delegate

extension ListDetailResultViewController: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.section == 0 ,
      let survey_Id = cheeseData?.cheeseData.id,
      let selectCell = collectionView.cellForItem(at: indexPath) else {return}
    self.selectAsk = selectCell.tag
    self.surveyId = survey_Id
    self.fetch(selectAsk: "\(selectCell.tag)", survey_id: surveyId!, reloadType: .circlebar)
    self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 1), at: .bottom, animated: true)
  }
}

//MARK: - DelegateFlowLayout
extension ListDetailResultViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if indexPath.section == 0{
      return CGSize(width: collectionView.frame.width, height: 40)
    }else {
      var height: CGFloat = 0
      
      switch indexPath.item {
      case 0:
        height = collectionView.frame.height/2 - 10
      case 1:
        height = collectionView.frame.height/2 - 10
      default:
        break
      }
      return CGSize(width: collectionView.frame.width, height: height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    if section == 0{
      return 0
    }
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    
    if section == 1{
      return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    return .zero
  }
}

extension ListDetailResultViewController: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "데이터가 비어있음"
    
    let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.white]
    return NSAttributedString(string: text, attributes: attributes)
  }
}


