//
//  SampleImageSelectVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources

public typealias tapURLAction = (String)->()

class SampleImageSelectVC: UIViewController, IndicatorInfoProvider{
  
  private let provider = CheeseService.provider
  private let disposeBag = DisposeBag()
  let datas = Variable<[BaseImageViewModel]>([])
  let imageSelected: PublishSubject<QuestionImageType>
  
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<BaseImageViewModel>(
    configureCell: {ds,cv,idx,item in
      let cell = cv.dequeueReusableCell(
        withReuseIdentifier: String(describing: ImgCollectionCell.self),
        for: idx) as! ImgCollectionCell
      
    cell.baseImg.kf.setImage(with: URL(string: item.img_url.getUrlWithEncoding()))
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ImgCollectionCell.self, forCellWithReuseIdentifier: String(describing: ImgCollectionCell.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  init(selectedImage: PublishSubject<QuestionImageType>) {
    self.imageSelected = selectedImage
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    provider.request(.getBaseImgList)
      .filter(statusCode: 200)
      .map(BaseImgModel.self)
      .map{[BaseImageViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .map{[unowned self] in self.datas.value[$0.section].items[$0.item].img_url}
      .subscribe(onNext: { [weak self] (url) in
        guard let `self` = self else {return}
        self.imageSelected.onNext(QuestionImageType.url(url))
        self.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
  }

  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "기본이미지")
  }
}

class ImgCollectionCell: UICollectionViewCell{
  
  let baseImg: UIImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(baseImg)
    baseImg.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
