//
//  ObjectMapper+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 9. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import ObjectMapper
import Moya
import RxSwift


extension ObservableType where E == Moya.Response {
  
  func map<T: Mappable>(_ mappableType: T.Type) -> Observable<T> {
    return self.mapString()
      .map { jsonString -> T in
        return Mapper<T>().map(JSONString: jsonString)!
      } 
      .do(onError: { error in
        if error is MapError {
          log.error(error)
        }
      })
  }
}
