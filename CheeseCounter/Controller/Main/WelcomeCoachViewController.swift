//
//  WelcomeCoachViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 8. 1..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Lottie

class WelcomeCoachViewController: UIViewController, UICollectionViewDelegate{
  
  var didTap:(()->Void)?
  
  let images = [#imageLiteral(resourceName: "5_answer_coach_mark_img"),#imageLiteral(resourceName: "5-1_answer_coach_mark"),#imageLiteral(resourceName: "6-1_list_coach_mark"),#imageLiteral(resourceName: "7-2_question_coach_mark")
    ,#imageLiteral(resourceName: "7-4-1_question_coach_mark"),#imageLiteral(resourceName: "8_alarm_coach_mark"),#imageLiteral(resourceName: "9_1-1_counter_gold_coach_mark")]
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.delegate = self
    view.dataSource = self
    view.backgroundColor = .white
    view.isPagingEnabled = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    collectionView.register(SendCheeseCell.self, forCellWithReuseIdentifier: String(describing: SendCheeseCell.self))
    collectionView.register(CoachImageCell.self, forCellWithReuseIdentifier: String(describing: CoachImageCell.self))
  }
}

extension WelcomeCoachViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
}

extension WelcomeCoachViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.item == 0{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SendCheeseCell.self), for: indexPath) as! SendCheeseCell
      cell.didTap = {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
      }
      return cell
    }else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CoachImageCell.self), for: indexPath) as! CoachImageCell
      cell.imgView.image = images[indexPath.item - 1]
      cell.didTap = {
        self.dismiss(animated: true, completion: {[weak self](_) in
          guard let tap = self?.didTap else {return}
          tap()
        })
      }
      return cell
    }
  }
}

fileprivate class SendCheeseCell: UICollectionViewCell{
  
  var didTap:(()->Void)?
  
  let mainTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "치즈 보상 획득!"
    label.font = UIFont.CheeseFontBold(size: 19)
    return label
  }()
  
  let imgView: UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "bg_gradation@1x"))
    return view
  }()
  
  let goldImg: LOTAnimationView = {
    let view = LOTAnimationView(name: "gold_reward")
    view?.animationSpeed = 0.5
    return view!
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    let attribute = NSMutableAttributedString(string: "+ 500골드", attributes: [NSFontAttributeName:UIFont.CheeseFontBold(size: 30),NSForegroundColorAttributeName:#colorLiteral(red: 0.9979653955, green: 0.4697954655, blue: 0.2858062387, alpha: 1)])
    attribute.append(NSAttributedString(string: "\n\n카운터에서 치즈내역을 확인하세요!",
                                        attributes: [
                                          NSFontAttributeName:UIFont.CheeseFontBold(size: 18),
                                          NSForegroundColorAttributeName:UIColor.lightGray]))
    label.adjustsFontSizeToFitWidth = true
    label.attributedText = attribute
    label.numberOfLines = 3
    label.textAlignment = .center
    return label
  }()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btn_next@1x"), for: .normal)
    button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    button.sizeToFit()
    return button
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(mainTitleLabel)
    contentView.addSubview(goldImg)
    contentView.addSubview(titleLabel)
    contentView.addSubview(dismissButton)
    
    contentView.backgroundColor = .white
    
    mainTitleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(80)
      make.height.equalTo(50)
      make.centerX.equalToSuperview()
    }
    
    goldImg.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(mainTitleLabel.snp.bottom).offset(5)
      make.width.equalTo(goldImg.snp.height)
      make.bottom.equalTo(titleLabel.snp.top)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(dismissButton.snp.top).offset(-50)
      make.centerX.equalToSuperview()
      make.height.equalTo(100)
    }
    
    dismissButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      make.width.equalTo(50)
      make.bottom.equalToSuperview().inset(52)
    }
    
    self.goldImg.play()
  }
  
  func dismissAction(){
    guard let tap = didTap else {return}
    tap()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

fileprivate class CoachImageCell: UICollectionViewCell{
  
  var didTap:(()->Void)?
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
    button.isUserInteractionEnabled = true
    return button
  }()
  
  let imgView: UIImageView = {
    let imgView = UIImageView()
    imgView.isUserInteractionEnabled = true
    return imgView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(imgView)
    contentView.insertSubview(dismissButton, aboveSubview: imgView)
    
    imgView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    dismissButton.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.topMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
  }
  
  fileprivate dynamic func dismissAction(_ sender: UIButton){
    guard let tap = didTap else {return}
    tap()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}




