//
//  CouponDetailViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 28..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

class CouponDetailViewController: UIViewController, UIScrollViewDelegate{
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 6.0
    scrollView.delegate = self
    return scrollView
  }()
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    
    return imageView
  }()
  
  init(image: UIImage?) {
    self.imageView.image = image
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view = scrollView
    scrollView.addSubview(imageView)
    
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
