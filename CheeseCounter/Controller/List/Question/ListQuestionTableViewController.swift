//
//  QuestionTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class ListQuestionViewController: BaseListViewController {
  
  override func setUp(){
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.defaultText = "최선의 선택을 위한 당신의 질문이 필요합니다."
    self.collectionView.register(BaseListCell.self, forCellWithReuseIdentifier: BaseListCell.ID)
  }
  
  override func fetch(paging: Paging){
    guard !self.isLoading else { return }
    self.isLoading = true
    CheeseService.getMyRegSurveyList(paging: paging) {[weak self] (response) in
      guard let `self` = self else {return}
      self.isLoading = false
      switch response.result {
      case .success(let data):
        let newData = data.data ?? []
        switch paging {
        case .refresh:
          self.cheeseData = newData
          self.nextPageNumber = 0
        case .next:
          guard !newData.isEmpty else {return}
          self.cheeseData.append(contentsOf: newData)
          self.nextPageNumber += 1
        }
        
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  func fetchSurveyResult(id:String){
    
    CheeseService.survayResult(surveyId: id) { [weak self] (response) in
      guard let `self` = self else {return}
      switch response.result {
      case .success(let value):
        self.resultData = value.data ?? []
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseListCell.ID, for: indexPath) as! BaseListCell
    cell.data = cheeseData[indexPath.item]
    return cell
  }
}
