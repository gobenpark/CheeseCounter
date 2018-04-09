//
//  CheeseTabViewController
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class CheeseTabViewController: ButtonBarPagerTabStripViewController {
  let disposeBag = DisposeBag()
  
  let tabViewControllers = [CheeseViewController(), AnswerableCheeseViewController()]
  
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
    barbutton.tintColor = .black
    return barbutton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pagerBehaviour = PagerTabStripBehaviour.common(skipIntermediateViewControllers: true)
    
    //self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1), height: 1)
    self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
    
    myPageButton.rx.tap
      .map {return MypageNaviViewController()}
      .subscribe(onNext: { [weak self](vc) in
        vc.modalPresentationStyle = .overCurrentContext
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .subscribe {[weak self] (_) in
        self?.navigationController?.pushViewController(CheeseViewController(isSearch: true), animated: false)
      }.disposed(by: disposeBag)
    
//    changeCurrentIndexProgressive = {
//      (oldCell: ButtonBarViewCell?
//      , newCell: ButtonBarViewCell?
//      , progressPercentage: CGFloat
//      , changeCurrentIndex: Bool
//      , animated: Bool) -> Void in
//
//      guard changeCurrentIndex == true else { return }
//      oldCell?.label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
//      newCell?.label.textColor = .black
//    }
    
    changeCurrentIndex = {
      (oldCell: ButtonBarViewCell?
      , newCell: ButtonBarViewCell?
      , animated: Bool) -> Void in
      oldCell?.label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
      newCell?.label.textColor = .black
    }
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    title = "응답"
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return tabViewControllers
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
    super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
    
    if fromIndex != toIndex {
        tabViewControllers[toIndex].initRequest()
    }
  }
}
