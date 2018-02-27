//
//  RxSwift+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import RxSwift


extension ObservableType where E == (ReplyModel){
  
  func replyMapper() -> Observable<[ReplyViewModel]>{
    return flatMap { (model) -> Observable<[ReplyViewModel]> in
        var copy = model
        var tempArray = [ReplyModel.Data]()
      for parent in model.result.data{
        if parent.parent_id == "0"{
          tempArray.append(parent)
          for child in model.result.data{
            if child.parent_id == parent.id{
              tempArray.append(child)
            }
          }
        }
      }
      log.info(copy.result.data)
        copy.result.data = tempArray
     return Observable<[ReplyViewModel]>.just([ReplyViewModel(items: copy.result.data)])
    }
  }
  
}
