//
//  PickerViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import XLPagerTabStrip
import TLPhotoPicker
import RxSwift
import RxCocoa
import Photos

class PickerViewController: ButtonBarPagerTabStripViewController{
  
  lazy var gararyViewController = TLPhotosPickerViewController(withPHAssets: {[weak self] (assets) in
    guard let asset = assets.first else {return}
    self?.getAssetThumbnail(asset: asset)
  })
  let disposeBag = DisposeBag()
  
  lazy var sampleImageViewController: SampleImageSelectVC = {
    let vc =  SampleImageSelectVC(selectedImage: self.imageSelected)
    return vc
  }()
  
  var configure = TLPhotosPickerConfigure()
  
  let imageSelected = PublishSubject<QuestionImageType>()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    title = "카운터"
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
    view.backgroundColor = .white
    buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    buttonBarView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    configure.doneTitle = "선택"
    configure.cancelTitle = String()
    
    configure.maxSelectedAssets = 1
    
    gararyViewController.configure = configure
    
  }
  
  func getAssetThumbnail(asset: PHAsset){
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    manager.requestImage(for: asset,
                         targetSize: CGSize(width: 500, height: 500),
                         contentMode: .aspectFit,
                         options: option){
                          [weak self] (image, info) in
                          guard let `self` = self, let image = image else {return}
      self.imageSelected.onNext(.image(image))
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [sampleImageViewController,gararyViewController]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


