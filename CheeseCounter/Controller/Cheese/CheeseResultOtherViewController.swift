//
//  CheeseResultOtherViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//  CheeseResultViewController 와 코드 중복

import UIKit


final class CheeseResultOtherViewController: CheeseBaseViewController {
  
  var cheeseData: CheeseResult?{
    didSet{
      self.survey_id = cheeseData?.cheeseData.id ?? ""
      fetchReply()
      self.collectionView.reloadData()
    }
  }
  
  lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(self.refreshControlDidChangeValue), for: .valueChanged)
    return refresh
  }()
  
  override func setUp() {
    self.collectionView.register(ResultOtherViewCell.self
      , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: ResultOtherViewCell.self))
    self.collectionView.register(RereplyViewCell.self, forCellWithReuseIdentifier: String(describing: RereplyViewCell.self))
    self.collectionView.addSubview(refreshControl)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9905284047, green: 0.8955592513, blue: 0.2977691889, alpha: 1), height: 2)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: .white, height: 2)
  }
  
  @objc func refreshControlDidChangeValue(){
    fetchReply()
    self.refreshControl.endRefreshing()
  }
  
  @objc func pushViewControllerAction(_ sender: UIGestureRecognizer){
    
    let resultVC = ListDetailResultViewController()
    var isZero: Bool = true
    
    guard let viewNumber = sender.view?.tag else {return}
    
    cheeseData?.resultData?.forEach({ (data) in
      if data.select_ask == "\(viewNumber)"{
        isZero = false
        return
      }
    })
    
    guard !isZero else {return}
    resultVC.selectAsk = sender.view?.tag
    resultVC.surveyId = self.survey_id
    resultVC.cheeseData = cheeseData
    self.navigationController?.pushViewController(resultVC, animated: true)
  }
  
  @objc fileprivate dynamic func cellTapAction(){
    self.replyTextView.endEditing(true)
  }
}

extension CheeseResultOtherViewController: UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectIndexPath = indexPath
  }
}

extension CheeseResultOtherViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = self.replyData[indexPath.row]
      .contents?
      .boundingRect(with: CGSize(width: 287.0, height: UIScreen.main.bounds.height)
        ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]).height
    return CGSize(width: collectionView.frame.width, height: (height ?? 0) + 60)
  }
}

extension CheeseResultOtherViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: ResultOtherViewCell.self)
      , for: indexPath) as! ResultOtherViewCell
    
    guard let sendCheeseData = self.cheeseData else {return view}
    view.graphDataUpdate(cheeseData: sendCheeseData)
    view.graphView.circleViews.forEach({ (view) in
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
        #selector(pushViewControllerAction)))
    })
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if cheeseData?.cheeseData.type ?? "" == "2"{
      if UIDevice.current.model == "iPad"{
        return CGSize(width: collectionView.frame.width, height: self.collectionView.frame.height - 50)
      }else{
        return CGSize(width: collectionView.frame.width, height: self.collectionView.frame.height - 200)
      }
    }else{
      return CGSize(width: collectionView.frame.width, height: self.collectionView.frame.height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RereplyViewCell.self), for: indexPath) as! RereplyViewCell
    cell.model = self.replyData[indexPath.row]
    cell.tag = indexPath.item
    cell.writeReplyButton.tag = indexPath.item
    cell.sympathyButton.tag = indexPath.item
    cell.writeReplyButton.addTarget(self, action: #selector(writeReReply(_:)), for: .touchUpInside)
    cell.sympathyButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(replyDeleteAction(_:)))
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapAction))
    cell.addGestureRecognizer(tapGesture)
    cell.addGestureRecognizer(longPressGesture)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return replyData.count
  }
}
