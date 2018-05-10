//
//  CheeseFilterViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 9..
//  Copyright © 2018년 xiilab. All rights reserved.
//


import XLPagerTabStrip
import DZNEmptyDataSet

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

class CheeseFilterViewController: UIViewController, DZNEmptyDataSetDelegate, IndicatorInfoProvider, UISearchControllerDelegate, CheeseDataRequestProtocol{
  
  private let disposeBag = DisposeBag()
  let cheeseDatas = Variable<[CheeseViewModel]>([])
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 6.5
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 6.5, right: 0)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    collectionView.backgroundColor = #colorLiteral(red: 0.9097241759, green: 0.9098549485, blue: 0.9096954465, alpha: 1)
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.model = item
//    cell.filterVC = self
    cell.indexPath = idx
    return cell
  })
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  var isLoading: Bool = false {
    didSet {
      collectionView.reloadEmptyDataSet()
    }
  }
  
  override func loadView() {
    super.loadView()
    view = collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initRequest()
    
    self.view.addSubview(activityView)
    
    activityView.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
    
    cheeseDatas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.willEndDragging
      .map{$0.0}
      .asDriver(onErrorJustReturn: .zero)
      .drive(onNext: navigationHidden)
      .disposed(by: disposeBag)
    
  }
  
  func initRequest() {
    requestSurveyList(reload: true)
  }

  private func requestSurveyList(reload: Bool) {
    let id = reload ? "" : (dataSources.sectionModels.last?.items.last?.id ?? "")
    var retryCount = 3
    
    CheeseService.provider.request(.getAvailableSurveyListV2(id: id))
      .filterSuccessfulStatusCodes()
      .map(MainSurveyList.self)
      .map {CheeseViewModel(items: $0.result.data)}
      .asObservable()
      .retryWhen({ (errorObservable: Observable<Error>) in
        return errorObservable.flatMap( { (err) -> Observable<Int> in
          if retryCount > 0 {
            retryCount -= 1
            return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
          } else {
            return Observable<Int>.error(err)
          }
        })
      })
      .catchErrorJustReturn(CheeseViewModel(items: []))
      .filter({ (model) -> Bool in
        return model.items.count != 0
      })
      .scan(cheeseDatas.value){ (state: [CheeseViewModel], viewModel: CheeseViewModel) -> [CheeseViewModel] in
        if reload {
          return [viewModel]
        } else {
          return state + viewModel
        }
      }
      .bind(to: cheeseDatas)
      .disposed(by: disposeBag)
  }
  
  private func navigationHidden(point: CGPoint){
    if point.y > 0{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      }, completion: nil)
    }else{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      }, completion: nil)
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "응답가능질문")
  }
}

extension CheeseFilterViewController: UICollectionViewDelegateFlowLayout{
  
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

extension CheeseFilterViewController {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
    if didReachBottom{
      requestSurveyList(reload: false)
    }
  }
}

extension CheeseFilterViewController: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = NSAttributedString(string: "모든 질문에 응답하셨거나\n\n아직 등록된 질문이 없어요.\n\n직접 질문을 등록해보세요."
      , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)
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
//{"code":"2001","data":"로그인 \354\204세션 기\352\260간이 만료 되었었\354습\353\213니\353\213니\353\213다"}
