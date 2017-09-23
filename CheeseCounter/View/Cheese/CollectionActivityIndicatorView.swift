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
    
    fileprivate var activityIndicatorView:NVActivityIndicatorView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType.ballRotate,
                                                        color: .black,
                                                        padding: NVActivityIndicatorView.DEFAULT_PADDING)
        self.activityIndicatorView?.startAnimating()
        self.addSubview(self.activityIndicatorView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      self.activityIndicatorView?.centerX = self.width/2
      self.activityIndicatorView?.centerY = self.height/2
        
    }
    
}
