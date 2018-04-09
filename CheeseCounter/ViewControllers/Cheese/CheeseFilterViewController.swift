//
//  CheeseFilterViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 9..
//  Copyright © 2018년 xiilab. All rights reserved.
//


import XLPagerTabStrip
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

class CheeseFilterViewController: UIViewController, IndicatorInfoProvider{
  
  private let disposeBag = DisposeBag()
  
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
  
  override func loadView() {
    super.loadView()
    view = collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    CheeseService.provider.request(.getAvailableSurveyListV2)
      .filterSuccessfulStatusCodes()
      .map(MainSurveyList.self)
      .subscribe(onSuccess: { (list) in
        log.info(list)
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "응답가능질문")
  }
}


//{"code":"2001","data":"로그인 \354\204세션 기\352\260간이 만료 되었었\354습\353\213니\353\213니\353\213다"}
