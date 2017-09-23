//
//  MainCheeseData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 7. 25..
//  Copyright © 2017년 xiilab. All rights reserved.
//
import UIKit

enum DateType{
  case premium
  case ordinary(date: String)
  
  var date: String{
    switch self {
    case .premium:
      return "유료질문"
    case .ordinary(let date):
      return date
    }
  }
}

struct CheeseDataSet{
  public var dateType: DateType = .premium
  public var data: [CheeseResultByDate.Data]?
}

final class MainCheeseData{
  
  open static let shared = MainCheeseData()
  public var mainData = [CheeseDataSet]()
  
  public func premiumSetting(value: CheeseResultByDate){
    
    self.mainData.removeAll()
    guard let datas = value.data else {return}
    
    let preminum = datas.filter { (data) -> Bool in
      return (data.is_option ?? "0") == "1" ? true : false
    }

    if !preminum.isEmpty{
      self.mainData.append(CheeseDataSet(dateType: .premium, data: preminum))
    }
    self.ordinarySetting(value: datas)
  }

  private func ordinarySetting(value: [CheeseResultByDate.Data]){
    
    var tempOrdinaryDictionary: [String:[CheeseResultByDate.Data]] = [:]
    for data in value{
      guard (data.is_option ?? "") == "0" else {continue}
      if let date = data.created_date?.components(separatedBy:" ")[0]{
        if tempOrdinaryDictionary[date] == nil{
          tempOrdinaryDictionary[date] = []
          tempOrdinaryDictionary[date]?.append(data)
        }else {
          tempOrdinaryDictionary[date]?.append(data)
        }
      }
    }
    
    let sortedData = tempOrdinaryDictionary.sorted { (data1, data2) -> Bool in
      return data1.key > data2.key
    }
    
    for (key,value) in sortedData{
      let data = CheeseDataSet(dateType: .ordinary(date: key), data: value)
      self.mainData.append(data)
    }
  }
  
  public func getData(from date: String) -> [CheeseResultByDate.Data]{
    for data in mainData{
      if data.dateType.date == date{
        return data.data ?? []
      }
    }
    return []
  }
  
}

