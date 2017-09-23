//
//  AlertViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import Toaster
import Moya
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class AlertViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfAlertData>()
  let cellViewModels = Variable<[SectionOfAlertData]>([])
  var currentPage = 0

  var isLoading:Bool = false{
    didSet{
      self.collectionView.reloadEmptyDataSet()
    }
  }

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.emptyDataSetDelegate = self
    collectionView.emptyDataSetSource = self
    collectionView.register(AlertViewCell.self, forCellWithReuseIdentifier: AlertViewCell.ID)
    collectionView.backgroundColor = .lightGray
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  let activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityView.frame = UIScreen.main.bounds
    return activityView
  }()
  
  let refresh: UIRefreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    self.view = collectionView
    self.view.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    self.navigationItem.title = "알림"
    self.collectionView.addSubview(refresh)
    
    configure()
    navigationBarSetup()
    fetch(paging: .refresh)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    cellViewModels.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .itemSelected
      .flatMap{(indexPath) -> Observable<(AlertType, String)> in
        let cell = self.collectionView.cellForItem(at: indexPath) as! AlertViewCell
        guard let type = cell.model?.type?.convertAlertType(),
          let id = cell.model?.target_id else {return Observable.empty()}
        return Observable.of((type, id))
      }.alertViewMapper()
      .bind(onNext: self.pushViewController)
      .disposed(by: disposeBag)
    
    collectionView.rx
      .contentOffset
      .filter { (point) in
        let data = point.y + self.collectionView.frame.size.height
        return data >= self.collectionView.contentSize.height ? true : false
    }.subscribe { [weak self](_) in
      guard let `self` = self else {return}
      self.fetch(paging: .next(self.currentPage))
    }.disposed(by: disposeBag)
    
    refresh.rx.controlEvent(.valueChanged)
      .subscribe { [weak self](event) in
        self?.fetch(paging: .refresh)
        self?.refresh.endRefreshing()
      }.disposed(by: disposeBag)
    
    globalTabEvent.filter { $0 == 3}
      .subscribe {[weak self] _ in
        self?.fetch(paging: .refresh)
    }.disposed(by: disposeBag)
  }
  
  private func pushViewController(VC: UIViewController){
    self.navigationController?.pushViewController(VC, animated: true)
  }
  
  private func getCheeseData(surveyID: String,_ completion: @escaping (CheeseResultByDate.Data?)-> Void){
    
    CheeseService.getSurveyById(surveyId: surveyID, {(response) in
      switch response.result{
      case .success(let value):
        completion(value.singleData)
      case .failure(let error):
        log.error("URL Setting data: \(error.localizedDescription)")
      }
    })
  }
  
  func navigationBarSetup(){
    
    let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    titleButton.setTitle("알림", for: .normal)
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
    coachView.imgView.image = coachView.images[4]
    self.present(coachView, animated: true, completion: nil)
  }

  fileprivate func fetch(paging: Paging){
    guard !self.isLoading else { return }
    self.isLoading = true
    CheeseService.getMyNotifications(paging: paging) {[weak self] (response) in
      guard let `self` = self else {return}
      switch response.result{
      case .success(let value):
        let newData = value.data ?? []
        switch paging {
        case .refresh:
          Observable.just(newData)
            .map{(customData)-> [SectionOfAlertData] in
              [SectionOfAlertData(items: customData)]
          }.bind(to: self.cellViewModels)
          .disposed(by: self.disposeBag)
          self.refresh.endRefreshing()
          self.currentPage = 0
        case .next:
          guard !newData.isEmpty else {return}
          self.cellViewModels.value.append(SectionOfAlertData(items: newData))
          self.currentPage += 1
        }
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
      self.isLoading = false
    }
  }
  
  func configure(){
    dataSource.configureCell = { ds, cv, ip, item in
      let cell = cv.dequeueReusableCell(withReuseIdentifier: AlertViewCell.ID, for: ip) as! AlertViewCell
      cell.model = item
      return cell
    }
  }
}

extension AlertViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: 75)
  }
}

extension AlertViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    
    let label = UILabel()
    label.textAlignment = .center 
    label.attributedText = NSAttributedString(string: "등록된 알림이 아직 없어요."
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
        ,NSForegroundColorAttributeName:UIColor.gray])
    self.activityView.startAnimating()
    
    if isLoading{
      return activityView
    }else{
      return label
    }
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}

