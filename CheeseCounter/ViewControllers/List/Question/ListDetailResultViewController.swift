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
import Eureka
import NVActivityIndicatorView

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

enum FoldAction{
  
  case Fold
  case Expand
}

enum reloadStateType{
  case barchart
  case all
  case circleChart
  case circlebar
}

struct ResultRank{
  enum RankType: Int{
    case ask1 = 1
    case ask2 = 2
    case ask3 = 3
    case ask4 = 4
    
    func title(model: CheeseViewModel.Item) -> String{
      switch self{
      case .ask1:
        return model.ask1
      case .ask2:
        return model.ask2
      case .ask3:
        return model.ask3 ?? String()
      case .ask4:
        return model.ask4 ?? String()
      }
    }
    
    func isSelected(num: Int) -> Bool{
      switch self{
      case .ask1:
        return num == 1
      case .ask2:
        return num == 2
      case .ask3:
        return num == 3
      case .ask4:
        return num == 4
      }
    }
  }
  let type: RankType
  let count: Int
}

class ListDetailResultViewController: FormViewController{
  
  let disposeBag = DisposeBag()
  var model: CheeseViewModel.Item
  var selectedAddress = ""
  var selectedNum: Int{
    didSet{
      request()
    }
  }
  let circleChart = CircleChartRow()
  let graphChart = DetailGraphRow()
  let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
  
  init(model: CheeseViewModel.Item, selectedNum: Int) {
    self.model = model
    self.selectedNum = selectedNum
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    self.tableView.separatorStyle = .none
    self.tableView.emptyDataSetSource = self
   
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.isNavigationBarHidden = false
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
    }
    
    view.addSubview(indicatorView)
    
    indicatorView.snp.makeConstraints { (make) in
      make.width.equalTo(50)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
      make.centerY.equalTo(view)
    }
    
    CheeseService.provider
      .request(.getDetailResult(survey_id: model.id, selectAsk: "\(self.selectedNum)", address: ""))
      .asObservable()
      .do(onSubscribed: {[weak self] in
        self?.indicatorView.startAnimating()
        self?.tableView.isHidden = true })
      .do(onDispose: {[weak self] in
        self?.indicatorView.stopAnimating()
        self?.tableView.isHidden = false })
      .map(ResultSurveyModel.self)
      .bind(onNext: showForm)
      .disposed(by: disposeBag)
  }
  
  private func request(){
    CheeseService.provider
      .request(.getDetailResult(survey_id: model.id, selectAsk: "\(self.selectedNum)", address: self.selectedAddress))
      .asObservable()
      .map(ResultSurveyModel.self)
      .bind(onNext: graphPatch)
      .disposed(by: disposeBag)
  }
  
  private func calculateRank() -> [ResultRank]{
    var tempArray = [ResultRank]()
    
    if let ask1 = Int(model.survey_result?.ask1_count ?? "0"),
      let ask2 = Int(model.survey_result?.ask2_count ?? "0"){
      tempArray.append(ResultRank(type: .ask1, count: ask1))
      tempArray.append(ResultRank(type: .ask2, count: ask2))
    }
    if model.type == "4"{
      if let ask3 = Int(model.survey_result?.ask3_count ?? "0"),
        let ask4 = Int(model.survey_result?.ask4_count ?? "0"){
        tempArray.append(ResultRank(type: .ask3, count: ask3))
        tempArray.append(ResultRank(type: .ask4, count: ask4))
      }
    }
    tempArray.sort { (lhs, rhs) -> Bool in
      return lhs.count > rhs.count
    }
    return tempArray
  }
  
  private func selectAction(foldType: FoldAction){
    let buttonRow = ButtonRow(){ row in
      row.title = (foldType == .Fold) ? "더보기" : "접기"
      row.cellSetup({ (cell, row) in
        cell.tintColor = .black
        cell.textLabel?.font = UIFont.CheeseFontBold(size: 10)
      })
      row.onCellSelection({[unowned self] (cell, row) in
        if row.title == "더보기"{
          self.selectAction(foldType: .Expand)
          row.title = "접기"
        }else{
          self.selectAction(foldType: .Fold)
          row.title = "더보기"
        }
        cell.update()
      })
    }
    var rankRows = [RankRow]()
    for (i,rank) in calculateRank().enumerated() {
      let tempRank = RankRow()
      tempRank.cellSetup({ [unowned self] (cell, row) in
        cell.tag = i + 1
        cell.countLabel.text = "\(rank.count)"
        cell.titleLabel.text = rank.type.title(model: self.model)
        cell.model = rank
      })
      tempRank.onCellSelection({[weak self] (cell, row) in
        guard let `self` = self else {return}
        self.selectedNum = cell.model?.type.rawValue ?? 0
      })
      rankRows.append(tempRank)
    }
    
    for section in form{
      if section.tag == "타이틀"{
        section.removeAll()
        switch foldType{
        case .Fold:
          for row in rankRows{
            if row.cell.model?.type.isSelected(num: self.selectedNum) ?? false{
              section <<< row
            }
          }
        case .Expand:
          for row in rankRows{
            section <<< row
          }
        }
        section <<< buttonRow
      }
    }
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  private func graphPatch(model: ResultSurveyModel){
    if self.selectedAddress == "" {
      circleChart.cellUpdate { (cell, row) in
        cell.dataFetch(datas: model)
      }
    }
    
    graphChart.cellUpdate { (cell, row) in
      cell.dataFetch(datas: model)
    }
    tableView.reloadData()
    tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
  }
  
  private func showForm(model: ResultSurveyModel){
    
    var rankRows = [RankRow]()
    let headerSection = Section(){
      var header = HeaderFooterView<UILabel>(.class)
      let size = self.model.title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 20, height: 100),
                                               attributes: [.font : UIFont.CheeseFontBold(size: 17)])
      header.height = {size.height + 10}
      header.onSetupView = { label,_ in
        label.backgroundColor = .white
        label.text = self.model.title
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.CheeseFontBold(size: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
      }
      $0.header = header
      $0.tag = "타이틀"
    }
    
    for (i,rank) in calculateRank().enumerated() {
      let tempRank = RankRow()
      tempRank.cellSetup({ [unowned self] (cell, row) in
        cell.tag = i + 1
        cell.countLabel.text = "\(rank.count)"
        cell.titleLabel.text = rank.type.title(model: self.model)
        cell.model = rank
      })
      rankRows.append(tempRank)
    }
    
    let buttonRow = ButtonRow(){ row in
      row.title = "더보기"
      row.cellSetup({ (cell, row) in
        cell.tintColor = .black
        cell.textLabel?.font = UIFont.CheeseFontBold(size: 10)
      })
      row.onCellSelection({[unowned self] (cell, row) in
        if row.title == "더보기"{
          self.selectAction(foldType: .Expand)
          row.title = "접기"
        }else{
          self.selectAction(foldType: .Fold)
          row.title = "더보기"
        }
        cell.update()
      })
    }
    
    for row in rankRows{
      if row.cell.model?.type.isSelected(num: self.selectedNum) ?? false{
        headerSection <<< row
      }
    }
    
    headerSection
      <<< buttonRow
    
    UIView.performWithoutAnimation {
      form.insert(headerSection, at: 0)
      form +++ circleChart.cellSetup({ (cell, row) in
        cell.dataFetch(datas: model)
      
        //차트가 선택될 때마다 하단의 성별 및 연령 정보 request//
        cell.didTap = { [weak self] country in
          guard let vc = self else {return}
          vc.selectedAddress = country
          vc.request()
        }
      })
      form +++ graphChart.cellSetup({ (cell, row) in
        cell.dataFetch(datas: model)
      })
    }
    
    tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.hidesBarsOnSwipe = true
  }
}

extension ListDetailResultViewController: DZNEmptyDataSetSource{

  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "데이터가 비어있음"
    
    let attributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.white]
    return NSAttributedString(string: text, attributes: attributes)
  }
}

extension UITableView {
  func scrollToBottom(animated: Bool) {
    let y = contentSize.height - frame.size.height
    setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
  }
}





