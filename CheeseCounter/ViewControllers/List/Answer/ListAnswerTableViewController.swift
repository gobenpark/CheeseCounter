//
//  AnswerTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class ListAnswerTableViewController: BaseListViewController {
  
  override func setUp(){
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.defaultText = "세상을 바꾸기 위한 당신의 한표가 필요합니다."
    self.collectionView.register(BaseListCell.self, forCellWithReuseIdentifier: BaseListCell.ID)
  }
  
  override func fetch(paging: Paging){
    
    guard !self.isLoading else { return }
    self.isLoading = true
    CheeseService.getMyAnswerSurveyList(paging: paging) {[weak self] (response) in
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
}

