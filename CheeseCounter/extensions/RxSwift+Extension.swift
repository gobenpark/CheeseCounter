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
      var dataArray = [ReplyModel.Data]()
      
      for parent in model.result.data{
        var tempArray = [ReplyModel.Data]()
        
        if parent.parent_id == "0"{
          for child in model.result.data{
            if child.parent_id == parent.id{
              tempArray.append(child)
            }
          }
        } else {
          continue
        }
        
        if tempArray.count > 0 {
          var copiedParent = parent
          copiedParent.hasReply = true
          tempArray.insert(copiedParent, at: 0)
        } else {
          tempArray.append(parent)
        }
        dataArray.append(contentsOf: tempArray)
      }
      copy.result.data = dataArray
      return Observable<[ReplyViewModel]>.just([ReplyViewModel(items: copy.result.data)])
    }
  }
  
}
