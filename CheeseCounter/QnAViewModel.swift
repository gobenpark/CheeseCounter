//
//  QnAViewModel.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxSwift
import RxCocoa

struct QnAViewModel{
  
  let title = Variable<String>(String())
  let comment = Variable<String>(String())
  
  let isVaild: Observable<Bool>
  
  init() {
    isVaild = Observable.combineLatest(title.asObservable(), comment.asObservable()) { (t, c) in
      return t.count > 0 && c.count > 0
    }
  }
}
