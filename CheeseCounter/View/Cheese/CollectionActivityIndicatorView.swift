//
//  CollectionActivityIndicatorView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import NVActivityIndicatorView


final class CollectionActivityIndicatorView: UICollectionReusableView {
  
  fileprivate var activityIndicatorView: NVActivityIndicatorView
  
  override init(frame: CGRect) {
    activityIndicatorView = NVActivityIndicatorView(frame: frame,
                            type: NVActivityIndicatorType.ballRotate,
                            color: .black,
                            padding: NVActivityIndicatorView.DEFAULT_PADDING)
   super.init(frame: frame)
    self.activityIndicatorView.startAnimating()
    self.addSubview(self.activityIndicatorView)
    
    activityIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
