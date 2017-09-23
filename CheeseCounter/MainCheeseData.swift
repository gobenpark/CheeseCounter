//
//  MainCheeseData.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 7. 25..
//  Copyright © 2017년 xiilab. All rights reserved.
//


final class MainCheeseData{
  
  open static let shared = MainCheeseData()
  
  public var premiumList:[CheeseResultByDate.Data] = []
  public var ordinaryDictionary: [String:[CheeseResultByDate.Data]] = [:]
  public var indexArray: [Int] = []
  public var dateList: [String] = []
  
  public func removeAll(){
    self.premiumList.removeAll()
    self.ordinaryDictionary.removeAll()
  }
  
  public func dateList() -> Int{
    var count = 0
    if !self.premiumList.isEmpty{
      count += 1
    }
    
    count += self.ordinaryDictionary.count
    
    self.indexArray = Array(repeating: 0, count: count)
    return count
  }
  
  private func dataSort(){
    
    self.dateList.removeAll()
    
    for (key,_) in MainCheeseData.shared.ordinaryDictionary{
      self.dateList.append(key)
    }
    
    self.dateList.sort()
    self.dateList.reverse()
    
    if !MainCheeseData.shared.premiumList.isEmpty && !dateList.isEmpty{
      self.dateList.insert("Premium", at: 0)
    }else if !MainCheeseData.shared.premiumList.isEmpty && dateList.isEmpty{
      self.dateList.append("Premium")
    }
  }
}
