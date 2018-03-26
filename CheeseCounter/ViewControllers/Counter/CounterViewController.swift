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
import iCarousel


class CounterViewController: ButtonBarPagerTabStripViewController{
  
  var item: [WinListModel.Data] = []
  let disposeBag = DisposeBag()
  
//  lazy var pageView: iCarousel = {
//    let cell = iCarousel()
//    cell.bounces = false
//    cell.type = .linear
//    cell.delegate = self
//    cell.dataSource = self
//    return cell
//  }()
 
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  
    title = "카운터"
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
//    self.view.addSubview(pageView)
//
//    pageView.snp.makeConstraints { (make) in
//      make.top.equalTo(self.buttonBarView.snp.bottom)
//      make.right.left.equalToSuperview()
//      make.height.equalTo(50)
//    }
//
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
    self.view.backgroundColor = .white
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
    
//    CheeseService.provider
//      .request(.getWinList)
//      .map(WinListModel.self)
//      .subscribe(onSuccess: { [weak self](model) in
//        self?.item = model.result.data
//      }) { (error) in
//        log.error(error)
//      }.disposed(by:disposeBag)

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
  }
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [GameSelectViewController(),ShopViewController()]
  }
}

//extension CounterViewController: iCarouselDataSource, iCarouselDelegate{
//  func numberOfItems(in carousel: iCarousel) -> Int {
//    return item.count
//  }
//
//  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//    let view = AdView(frame: carousel.bounds)
//    view.model = item[index]
//    return view
//  }
//
//  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//    if (option == .wrap) {
//      log.info(value)
//      return 9
//    }
//    return value
//  }
//}

