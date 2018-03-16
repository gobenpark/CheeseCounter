//
//  SampleImageSelectVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

public typealias tapURLAction = (String)->()

class SampleImageSelectVC: UIViewController{
  
  var imgs: [BaseImg.Data] = []{
    didSet{
      self.collectionView.reloadData()
    }
  }
  
  var didTap: tapURLAction?
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ImgCollectionCell.self, forCellWithReuseIdentifier: "imgCollectionCell")
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view = collectionView
    let barbutton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(dismissAction))
    barbutton.tintColor = .blue
    self.navigationItem.rightBarButtonItem = barbutton
    
    fetch()
  }
  
  func fetch(){
    
    CheeseService.getBaseImg { (response) in
      switch response.result{
      case .success(let value):
        guard let datas = value.data else {return}
        self.imgs = datas
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  @objc func dismissAction(){
    
    self.navigationController?.popViewController(animated: true)
  }
}

extension SampleImageSelectVC: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let tap = didTap else { return }
    tap(imgs[indexPath.item].img_url ?? "")
    self.dismissAction()
  }
}

extension SampleImageSelectVC: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return imgs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCollectionCell", for: indexPath) as? ImgCollectionCell
    cell?.layer.borderWidth = 1
    cell?.layer.borderColor = UIColor.white.cgColor
    let imgurl = self.imgs[indexPath.row].img_url ?? ""
    cell?.baseImg.kf.setImage(with: URL(string: imgurl.getUrlWithEncoding()))
    return cell ?? UICollectionViewCell()
  }
}

extension SampleImageSelectVC: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
  }
}

class ImgCollectionCell: UICollectionViewCell{
  
  let baseImg:UIImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(baseImg)
    baseImg.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
