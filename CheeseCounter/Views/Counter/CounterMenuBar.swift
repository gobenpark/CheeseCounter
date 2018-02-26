////
////  CunterProfileCell.swift
////  CheeseCounter
////
////  Created by 박범우 on 2017. 4. 4..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//import SnapKit
//
//class CounterMenuBar: UIView{
//
//  var menuString: [String] = ["1","2"]{
//    didSet{
//      self.collectionView.reloadData()
//    }
//  }
//  var bottomConstraint:Constraint?
////  var currentViewController: CurrentBaseViewController?
//
//  lazy var collectionView: UICollectionView = {
//    let layout = UICollectionViewFlowLayout()
//    layout.minimumLineSpacing = 0
//    layout.scrollDirection = .horizontal
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.dataSource = self
//    collectionView.delegate = self
//    collectionView.backgroundColor = .white
//    collectionView.register(CounterMenuBarCell.self, forCellWithReuseIdentifier: CounterMenuBarCell.ID)
//    collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
//    return collectionView
//  }()
//
//  let bottomView: UIView = {
//    let view = UIView()
//    view.backgroundColor = .black
//    return view
//  }()
//
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
//
//  convenience init(menuString: [String],frame: CGRect) {
//    self.init(frame: frame)
//    self.menuString = menuString
//    addSubview(collectionView)
//    addSubview(bottomView)
//
//    setUp()
//
//    collectionView.snp.makeConstraints { (make) in
//      make.edges.equalToSuperview()
//    }
//
//    bottomView.snp.makeConstraints { (make) in
//      make.bottom.equalToSuperview()
//      bottomConstraint = make.left.equalToSuperview().constraint
//      make.width.equalToSuperview().dividedBy(menuString.count)
//      make.height.equalTo(2)
//    }
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  func setUp(){}
//}
//
//extension CounterMenuBar: UICollectionViewDelegate {
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    currentViewController?.scrollToMenuIndex(indexPath.item)
//  }
//}
//
//extension CounterMenuBar: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return self.menuString.count
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CounterMenuBarCell.ID, for: indexPath) as! CounterMenuBarCell
//    cell.menuLabel.text = menuString[indexPath.row]
//    return cell
//  }
//}
//
//extension CounterMenuBar: UICollectionViewDelegateFlowLayout{
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: self.frame.width/CGFloat(menuString.count), height: self.frame.height)
//  }
//}
//
//class CounterMenuBarCell: UICollectionViewCell{
//
//  static let ID = "CounterMenuBarCell"
//
//  override var isSelected: Bool {
//    didSet{
//      menuLabel.textColor = isSelected ? .black : .lightGray
//      menuLabel.font = isSelected ? .CheeseFontBold(size: 16) : .CheeseFontMedium(size: 16)
//    }
//  }
//
//  let menuLabel: UILabel = {
//    let label = UILabel()
//    label.sizeToFit()
//    label.font = UIFont.CheeseFontMedium(size: 16)
//    label.textColor = .lightGray
//    return label
//  }()
//
//  let bottomView: UIView = {
//    let view = UIView()
//    view.backgroundColor = .lightGray
//    return view
//  }()
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    addSubview(menuLabel)
//    addSubview(bottomView)
//
//    menuLabel.snp.makeConstraints { (make) in
//      make.centerX.equalToSuperview()
//      make.centerY.equalToSuperview()
//    }
//
//    bottomView.snp.makeConstraints{ (make) in
//      make.bottom.equalToSuperview()
//      make.left.equalToSuperview()
//      make.right.equalToSuperview()
//      make.height.equalTo(2)
//    }
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}

