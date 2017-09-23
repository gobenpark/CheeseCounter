//
//  ImagePickerViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

import ALCameraViewController
import BetterSegmentedControl
import AAFragmentManager

public typealias tapCallBack = ((Data) -> ())


class ImagePickerViewController: UIViewController {
  
  var didTap:tapCallBack?
  var urlCallBack: tapURLAction?
  let sampleImageSelectVC = SampleImageSelectVC()
  let extendedNavBarView: ExtendedNavBarView = {
    let NavBarView = ExtendedNavBarView()
    NavBarView.titles = ["기본 이미지","갤러리","카메라"]
    return NavBarView
  }()
  
  let setUpPageViewController = SetUpPageViewController(transitionStyle: .scroll
    , navigationOrientation: .horizontal, options: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    let sampleImageSelectVC = SampleImageSelectVC()
    sampleImageSelectVC.didTap = self.urlCallBack
    
    
    let cameraViewController = CameraViewController(croppingEnabled: true
    , allowsLibraryAccess: true) { [weak self] image, asset in
      
      if let image = UIImage.resizeImage(image: image ?? UIImage(), newWidth: 500), let tap = self?.didTap {
        guard let data = UIImageJPEGRepresentation(image, 1) else {return}
        tap(data)
        self?.dismiss(animated: true, completion: nil)
      }
      self?.navigationController?.popToRootViewController(animated: true)
    }
    
    let libraryViewController = CameraViewController
      .imagePickerViewController(croppingEnabled: true) { [weak self] image, asset in
        
        if let image = UIImage.resizeImage(image: image ?? UIImage(), newWidth: 500), let tap = self?.didTap{
          guard let data = UIImageJPEGRepresentation(image, 1) else {return}
          tap(data)
          self?.dismiss(animated: true, completion: nil)
        }
        self?.navigationController?.popToRootViewController(animated: true)
    }
    
    let viewControllers = [sampleImageSelectVC,libraryViewController,cameraViewController]
    setUpPageViewController.pageViewControllers = viewControllers
    setUpPageViewController.Delegate = self
    
    self.addChildViewController(setUpPageViewController)
    self.view.addSubview(extendedNavBarView)
    self.view.addSubview(setUpPageViewController.view)
    
    extendedNavBarView.segmentedControl.addTarget(self, action: #selector(segmentControlEvent(_:)), for: .valueChanged)
    extendedNavBarView.backgroundColor = .white
    extendedNavBarView.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    
    extendedNavBarView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(80)
    }
    
    setUpPageViewController.view.snp.makeConstraints { (make) in
      make.top.equalTo(extendedNavBarView.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: .white, height: 2)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
  }
  
  
  
  fileprivate dynamic func segmentControlEvent(_ sender: BetterSegmentedControl){
    setUpPageViewController.scrollToViewController(index: Int(sender.index))
  }
}
extension CameraViewController {
  /// Provides an image picker wrapped inside a UINavigationController instance
  public class func imagePickerViewController(croppingEnabled: Bool, completion: @escaping CameraViewCompletion) -> UINavigationController {
    let imagePicker = PhotoLibraryViewController()
    let navigationController = UINavigationController(rootViewController: imagePicker)
    
    navigationController.navigationBar.barTintColor = UIColor.black
    navigationController.navigationBar.barStyle = UIBarStyle.black
    navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    imagePicker.onSelectionComplete = { [weak imagePicker] asset in
      if let asset = asset {
        let confirmController = ConfirmViewController(asset: asset, allowsCropping: croppingEnabled)
        confirmController.onComplete = { [weak imagePicker] image, asset in
          if let image = image, let asset = asset {
            completion(image, asset)
          } else {
            imagePicker?.dismiss(animated: true, completion: nil)
          }
        }
        confirmController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        imagePicker?.present(confirmController, animated: true, completion: nil)
      } else {
        completion(nil, nil)
      }
    }
    
    return navigationController
  }
}

extension ImagePickerViewController: SetUpPageViewControllerDelegate{
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageCount count: Int){
    
  }
  
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageIndex index: Int){
    do {
      try extendedNavBarView.segmentedControl.setIndex(UInt(index))
    } catch let error{
      log.error(error.localizedDescription)
    }
  }
  
}


