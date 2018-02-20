//
//  currentCheeseTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import SnapKit
import Spring

class CurrentGoldViewController: CurrentBaseViewController
{
  
  var goldReturnData = GoldReturnData()
  
  lazy var bankVC: UINavigationController = {
    let bankVC = BankSelectViewController()
    bankVC.modalPresentationStyle = .overCurrentContext
    bankVC.bankCallBackMethod = self.bankCallBack(bankName:)
    let naviVC = UINavigationController(rootViewController: bankVC)
    return naviVC
  }()
  
  override func setUp(){
    self.view.addSubview(collectionView)
    
    collectionView.dataSource = self
    collectionView.register(CurrentGoldViewCell.self, forCellWithReuseIdentifier: CurrentGoldViewCell.ID)
    collectionView.register(PayForGoldViewCell.self, forCellWithReuseIdentifier: PayForGoldViewCell.ID)
    collectionView.register(SaleGoldViewCell.self, forCellWithReuseIdentifier: SaleGoldViewCell.ID)
    collectionView.register(tempCell.self,forCellWithReuseIdentifier: String(describing: tempCell.self))
    counterMenuBar = CounterMenuBar(menuString: ["골드 내역","골드 구매","골드 판매"], frame: .zero)
    counterMenuBar.currentViewController = self
    
    self.view.addSubview(counterMenuBar)
    
    counterMenuBar.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalToSuperview().dividedBy(9)
    }
    
    collectionView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(counterMenuBar.snp.bottom)
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    
    PointService.getMyPointHistory(parameter: parameter) { (response) in
      switch response.result{
      case .success(let value):
        print(value)
      case .failure(let error):
        print(error)
      }
    }
  }
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CurrentGoldViewCell{
      cell.calendarView.emptyTextView.endEditing(true)
    }
    
    let index = targetContentOffset.pointee.x / view.frame.width
    let indexPath = IndexPath(item: Int(index), section: 0)
    counterMenuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
  }
  
  @objc func upLoadData(_ sender: SpringButton){
    var parameter:[String:String] = [:]
    for (key,value) in Mirror(reflecting: self.goldReturnData).children{
      guard let key = key else {return}
      parameter[key] = "\(value)"
    }
    
    PointService.insertGoldReturn(parameter: parameter) {[weak self] (status,data) in
      guard let `self` = self else {return}
      if status == "200" {
        let cheeseSaleVC = CheeseSaleCompleteVC()
        cheeseSaleVC.titleLabel.text = "\(self.goldReturnData.cash)원\n판매요청 되었습니다."
        cheeseSaleVC.subTitleLabel.text = "입력하신계좌를 통하여 입금됩니다.\n만일 계좌번호와 예금주가 동일하지 않을 경우\n입금은 자동 취소가 되며, 골드로 전환됩니다."
        cheeseSaleVC.callBack = {
          self.goldReturnData = GoldReturnData()
          self.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
        }
        AppDelegate.instance?.window?.rootViewController?.present(cheeseSaleVC, animated: true, completion: nil)
      } else {
        AlertView(title: "알림", message: data, preferredStyle: .alert)
          .addChildAction(title: "확인", style: .default, handeler: nil)
          .show()
        self.animationView(sender)
      }
    }
  }
  
  func animationView(_ sender: SpringButton){
    sender.animation = "shake"
    sender.curve = "easeInOutCubic"
    sender.force = 1.1
    sender.duration = 0.5
    sender.animate()
  }
  
  @objc func popUpBankSelectView(_ sender: UIButton){
    AppDelegate.instance?.window?.rootViewController?.present(bankVC, animated: true, completion: nil)
  }
  
  func bankCallBack(bankName:String){
    self.goldReturnData.bank = bankName
    self.collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
  }
}

extension CurrentGoldViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView
    ,numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView
    ,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.item {
    case 0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentGoldViewCell.ID, for: indexPath) as! CurrentGoldViewCell
      return cell
    case 1:
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayForGoldViewCell.ID, for: indexPath) as! PayForGoldViewCell
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: tempCell.self), for: indexPath) as! tempCell
      return cell
    case 2:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SaleGoldViewCell.ID, for: indexPath) as! SaleGoldViewCell
      cell.selectBankButton.addTarget(self, action: #selector(popUpBankSelectView(_:)), for: .touchUpInside)
      cell.salesButton.addTarget(self, action: #selector(upLoadData), for: .touchUpInside)
      cell.currentGoldViewController = self
      cell.selectBankButton.setTitle(self.goldReturnData.bank, for: .normal)
      return cell
    default:
      break
    }
    return UICollectionViewCell()
  }
}

final class tempCell: UICollectionViewCell{
  
  let tempLabel: UILabel = {
    let label = UILabel()
    label.text = "준비중입니다."
    label.font = UIFont.CheeseFontBold(size: 16)
    label.textColor = .black
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(tempLabel)
    
    tempLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    tempLabel.sizeToFit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}




