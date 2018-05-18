//
//  AnswerViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift
import RxDataSources
import Moya
import DZNEmptyDataSet

class AnswerViewController: BaseListViewController, IndicatorInfoProvider{
  
  lazy var updateSurvey: (MainSurveyList.CheeseData, IndexPath) -> Void = { model, indexPath in
    self.datas.value[indexPath.section].items[indexPath.item] = model
    self.collectionView.reloadItems(at: [indexPath])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.emptyDataSetSource = self
    collectionView.register(AnswerViewCell.self, forCellWithReuseIdentifier: "cell")
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    request(requestType: .reload)
    
    collectionView.rx
      .itemSelected
      .map {[unowned self] idx in (self.datas.value[idx.section].items[idx.item],idx)}
      .flatMap({ (data)  in
        return CheeseService.provider.request(.getSurveyByIdV2(id: data.0.id))
          .filter(statusCode: 200)
          .map(MainSurveyList.self)
          .map{ $0.result.data.first}
          .asObservable()
          .filterNil()
          .map{($0,data.1)}
      })
      .subscribe (onNext:{ [weak self] (data) in
        guard let `self` = self else {return}
        self.navigationController?.pushViewController(ReplyViewController(model: data.0,indexPath: data.1, updateSurvey: self.updateSurvey), animated: true)
        },onError:{ error in
          log.error(error)
      }).disposed(by: disposeBag)
  }
   
  override func request(requestType: RequestAction) {
    switch requestType{
    case .reload:
      var retryCount = 3
        provider.request(.getMyAnswerSurveyList(pageNum: "0"))
          .filter(statusCode: 200)
          .map(MainSurveyList.self)
          .map{[CheeseViewModel(items: $0.result.data)]}
          .do(onSuccess: { [weak self](_) in
            self?.refreshView.endRefreshing()
          })
          .asObservable()
          .retryWhen{ (errorObservable: Observable<Error>) in
            return errorObservable.flatMap({ (err) -> Observable<Int> in
              if retryCount > 0 {
                retryCount -= 1
                return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
              } else {
                return Observable<Int>.error(err)
              }
            })}
          .catchErrorJustReturn([CheeseViewModel(items: [])])
          .filter({ (model) in
            return model[0].items.count > 0
          })
          .bind(to: datas)
          .disposed(by: disposeBag)
    case .paging(let pageNum):
      var retryCount = 3
      provider.request(.getMyAnswerSurveyList(pageNum: pageNum))
        .filter(statusCode: 200)
        .map(MainSurveyList.self)
        .map{[CheeseViewModel(items: $0.result.data)]}
        .do(onSuccess: { [weak self](_) in
          self?.refreshView.endRefreshing()
        })
        .asObservable()
        .retryWhen{ (errorObservable: Observable<Error>) in
          return errorObservable.flatMap({ (err) -> Observable<Int> in
            if retryCount > 0 {
              retryCount -= 1
              return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
            } else {
              return Observable<Int>.error(err)
            }
          })}
        .catchErrorJustReturn([CheeseViewModel(items: [])])
        .filter({ (model) in
          return model[0].items.count > 0
        })
        .scan(datas.value){ (state, viewModel) in
          return state + viewModel
        }
        .bind(to: datas)
        .disposed(by: disposeBag)
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "응답")
  }
}

extension AnswerViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "아직 질문에 응답하지 않으셨습니다.", attributes: [.font: UIFont.CheeseFontMedium(size: 13)])
  }
}
