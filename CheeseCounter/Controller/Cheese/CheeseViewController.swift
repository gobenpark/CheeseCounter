//
//  sample.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import RxSwift
import RxCocoa
import RxDataSources
import Moya

enum PagingType{
  case premium(id: String)
  case ordinary(id: String)
}

class CheeseViewController: UIViewController, DZNEmptyDataSetDelegate
{
  
  //MARK: - Property
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<CheeseCounter>().rx
  let cheeseDatas = Variable<[CheeseViewModel]>([])
  let buttonEvent = PublishSubject<(Int,MainSurveyList.CheeseData)>()
  let moreEvent = PublishSubject<Int>()
  
  var moreDict: [Int: Bool] = [:]
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell: {[weak self] ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: MainViewCell.self), for: idx) as! MainViewCell
    cell.model = item
    cell.indexPath = idx
    cell.cheeseVC = self
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 6.5
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: String(describing: MainViewCell.self))
    collectionView.backgroundColor = #colorLiteral(red: 0.9097241759, green: 0.9098549485, blue: 0.9096954465, alpha: 1)
    collectionView.alwaysBounceVertical = true
    collectionView.isPrefetchingEnabled = false
    return collectionView
  }()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  let searchButton: UIBarButtonItem = {
    let barbutton = UIBarButtonItem()
    barbutton.image = #imageLiteral(resourceName: "header_search@1x").withRenderingMode(.alwaysTemplate)
    barbutton.style = .plain
    return barbutton
  }()
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  let refreshView: UIRefreshControl = {
    let view = UIRefreshControl()
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  //MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view = collectionView
    collectionView.addSubview(refreshView)
    self.navigationController?.hidesBarsOnSwipe = true
    
    myPageButton.rx.tap
      .map{ _ in return MyPageViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    cheeseDatas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    refreshView.rx
      .controlEvent(.valueChanged)
      .subscribe { [weak self](event) in
        self?.networkRequest(id: String())
        self?.refreshView.endRefreshing()}
      .disposed(by: disposeBag)
    
    buttonEvent.observeOn(MainScheduler.instance)
      .flatMap { [unowned self] (data) in
        return self.provider
          .request(.insertSurveyResult(surveyId: data.1.id, select: "\(data.0)"))
          .filter(statusCode: 200)
          .map{ _ in
            return data.1
        }
      }
      .bind(onNext: showGiftView)
      .disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      collectionView.contentInsetAdjustmentBehavior = .never
    }
    
//    definesPresentationContext = true //중요
    
    networkRequest(id: String())
    navigationBarSetup()
  }
  
  private func showGiftView(data:MainSurveyList.CheeseData){
    let giftView = GifViewController()
    giftView.imageType = .cheese
    giftView.modalPresentationStyle = .overCurrentContext
    giftView.modalTransitionStyle = .flipHorizontal
    
    giftView.dismissCompleteAction = {[weak self] in
      guard let retainSelf = self else {return}
      retainSelf.navigationController?.pushViewController(ReplyViewController(model: data), animated: true)
    }
    self.present(giftView, animated: true, completion: nil)
  }
  
  private func networkRequest(id: String){
    
    provider.request(.getSurveyListV2(id: id))
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
  
  private func navigationBarSetup(){
    
    let titleLabel = UILabel()
    titleLabel.text = "응답"
    titleLabel.font = UIFont.CheeseFontBold(size: 17)
    titleLabel.sizeToFit()
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
    self.navigationItem.titleView = titleLabel
  }
  
  @objc private dynamic func searchViewPresent(){
    let searchView = UINavigationController(rootViewController: SearchListViewController(type: .main))
    searchView.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(searchView, animated: false, completion: nil)
  }
}

extension CheeseViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {

    switch self.dataSources.sectionModels.first?.items[indexPath.item].type{
    case "2"?:
      if moreDict[indexPath.item,default:false]{
        return CGSize(width: collectionView.frame.width, height: 370)
      }
      return CGSize(width: collectionView.frame.width, height: 340)
    case "4"?:
      if moreDict[indexPath.item,default:false]{
        return CGSize(width: collectionView.frame.width, height: 570)
      }
      return CGSize(width: collectionView.frame.width, height: 520)
    default:
      return CGSize(width: collectionView.frame.width, height: 340)
    }
  }
}

extension CheeseViewController{
    
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
     if didReachBottom{
      networkRequest(id: dataSources.sectionModels.last?.items.last?.id ?? "")
    }
  }
}
func + <T>(lhs: [T], rhs: T) -> [T] {
  var copy = lhs
  copy.append(rhs)
  return copy
}

extension CheeseViewController: DZNEmptyDataSetSource{

  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = NSAttributedString(string: "모든 질문에 응답하셨거나\n\n아직 등록된 질문이 없어요.\n\n직접 질문을 등록해보세요."
      , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])

    activityView.startAnimating()
    return activityView

//    if isLoading{
//      return activityView
//    }else {
//      return label
//    }
  }

  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}


