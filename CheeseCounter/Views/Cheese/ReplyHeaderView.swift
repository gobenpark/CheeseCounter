//
//  ReplyHeaderView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 6..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

final class ReplyHeaderView: UICollectionReusableView{
  
  var model: MainSurveyList.CheeseData?{
    didSet{
      mainView.model = model
    }
  }
  
  let mainView = MainCheeseView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(mainView)
    
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
