//
//  AlertViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import Moya
import Toaster
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
  import RxDataSources
#endif

class AlertViewController: UIViewController{
  let provider = CheeseService.provider
  var isPaging: Bool = false
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  let disposeBag = DisposeBag()
  let dataSource = RxCollectionViewSectionedReloadDataSource<AlertViewModel>(configureCell: { ds, cv, ip, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: AlertViewCell.ID, for: ip) as! AlertViewCell
    cell.model = item
    return cell
  })
  let datas = Variable<[AlertViewModel]>([])
  var currentPage = 1

  var isLoading:Bool = false{
    didSet{
      self.collectionView.reloadEmptyDataSet()
    }
  }

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 75)
    layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.emptyDataSetDelegate = self
    collectionView.emptyDataSetSource = self
    collectionView.register(AlertViewCell.self, forCellWithReuseIdentifier: AlertViewCell.ID)
    collectionView.backgroundColor = .lightGray
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
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
    
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx
      .itemSelected
      .subscribe{
        Toast(text: "준비중입니다.", delay: 0.4, duration: 1).show()
      }.disposed(by: disposeBag)
    
    
//      .flatMap{(indexPath) -> Observable<(AlertType, String)> in
//        let cell = self.collectionView.cellForItem(at: indexPath) as! AlertViewCell
//        guard let type = cell.model?.type?.convertAlertType(),
//          let id = cell.model?.target_id else {return Observable.empty()}
//        return Observable.of((type, id))
//      }.alertViewMapper()
//      .subscribe(onNext: {[weak self] (vc) in
//        self?.navigationController?.pushViewController(vc, animated: true)
//      }).disposed(by: disposeBag)

    
    refresh.rx
      .controlEvent(.valueChanged)
      .subscribe { [weak self](event) in
        self?.request(of: .reload)
        self?.refresh.endRefreshing()
      }.disposed(by: disposeBag)
    
    globalTabEvent
      .filter { $0 == 3}
      .subscribe {[weak self] _ in
        self?.request(of: .reload)
    }.disposed(by: disposeBag)
    
    request(of: .reload)
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
  
  @objc func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[4]
    self.present(coachView, animated: true, completion: nil)
  }
  
  private func request(of type: RequestAction){
    switch type{
    case .reload:
      currentPage = 1
      provider.request(.getMyNotification(pageNum: "0"))
        .filter(statusCode: 200)
        .map(NotiModel.self)
        .map{[AlertViewModel(items: $0.result.data)]}
        .asObservable()
        .bind(to: datas)
        .disposed(by: disposeBag)
    case .paging(let id):
      guard !isPaging else {return}
      isPaging = true
      provider.request(.getMyNotification(pageNum: id))
        .filter(statusCode: 200)
        .map(NotiModel.self)
        .asObservable()
        .filter{!$0.result.data.isEmpty}
        .map{[AlertViewModel(items: $0.result.data)]}
        .do(onNext: { [weak self](_) in
          self?.refresh.endRefreshing()
          self?.currentPage += 1
          self?.isPaging = false
        })
        .scan(datas.value){ (state, viewModel) in
          return state + viewModel
        }.bind(to: datas)
        .disposed(by: disposeBag)
    }
  }
}

extension AlertViewController: UICollectionViewDelegate{
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 50
    if didReachBottom{
      request(of: .paging("\(currentPage)"))
    }
  }
}

extension AlertViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    
    let label = UILabel()
    label.textAlignment = .center 
    label.attributedText = NSAttributedString(string: "등록된 알림이 아직 없어요."
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
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

