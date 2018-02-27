//
//  NewCounterViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import XLPagerTabStrip
import FSPagerView

class CounterViewController: ButtonBarPagerTabStripViewController{
  
  let disposeBag = DisposeBag()
  var winModel: WinListModel?{
    didSet{
//      self.pagerView.reloadData()
    }
  }
  
  let pageView: BannerViewController = BannerViewController()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    let titleLabel = UILabel()
    titleLabel.text = "카운터"
    titleLabel.font = UIFont.CheeseFontBold(size: 17)
    titleLabel.sizeToFit()
    self.navigationItem.titleView = titleLabel
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
    
    pageView.pages.append(Banner())
    pageView.pages.append(Banner())
    pageView.pages.append(Banner())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.addChildViewController(pageView)
    self.view.addSubview(pageView.view)
    
    pageView.view.snp.makeConstraints { (make) in
      make.top.equalTo(self.buttonBarView.snp.bottom)
      make.right.left.equalToSuperview()
      make.height.equalTo(50)
    }
    
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
    
    self.view.backgroundColor = .white
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
    
    CheeseService.provider.rx.request(.getWinList)
      .map(WinListModel.self)
      .asObservable()
      .debug()
      .flatMap({ (model) -> Observable<[Banner]> in
        var banners = [Banner]()
        for data in model.result.data{
          let banner = Banner()
          banner.model = data
          banners.append(banner)
        }
        return Observable.just(banners)
      })
      .subscribe(onNext:{[weak self] (banner) in
        log.info(self)
        self?.pageView.pages = banner
      }).disposed(by: disposeBag)
    
    myPageButton.rx.tap
      .map {return MypageNaviViewController()}
      .subscribe(onNext: { [weak self](vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    changeCurrentIndexProgressive = {
      (oldCell: ButtonBarViewCell?
      , newCell: ButtonBarViewCell?
      , progressPercentage: CGFloat
      , changeCurrentIndex: Bool
      , animated: Bool) -> Void in
      
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
      newCell?.label.textColor = .black
    }
    
    Observable.interval(3, scheduler: MainScheduler.instance)
      .subscribe { (_) in
        log.info("print")
    }.disposed(by: disposeBag)
    
    
    
  }
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [GameSelectViewController(),ShopViewController()]
  }
}

