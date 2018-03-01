//
//  ViewController.swift
//  wheelsample
//
//  Created by xiilab on 2017. 12. 28..
//  Copyright © 2017년 bumwoo. All rights reserved.
//

import UIKit
import FlexibleImage
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import Toaster
import GameplayKit
import PMAlertController
import Kingfisher

enum StageStatus: Int{
  case first = 1
  case middle = 2
  case last = 3
  case `default` = 0
}

class GameViewController: UIViewController , SpinWheelControlDataSource, SpinWheelControlDelegate {
  
  let cheeseIcons = [#imageLiteral(resourceName: "cheeseEmental"),#imageLiteral(resourceName: "cheeseGorgonzola"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseColbyjack"),#imageLiteral(resourceName: "cheeseGauda"),#imageLiteral(resourceName: "cheeseHavati"),#imageLiteral(resourceName: "cheeseBrick")]
  var userRouletteFirstTouch: Bool = false
  var images: [UIImage]
  var isPresentingForFirstTime: Bool = false
  var isPopViewControllerAgree: Bool = false
  var patterns:[Array<Substring>] = []
  var stageStatus: StageStatus = .default
  var gameID = ""
  var startGame: Bool = false
  var pointModel: PointModel?
  
  var history: [Int] = []
  var selectedHistory: [Int] = []
  var currentLevel: Int = 0
  private var selectedImages: NSArray = []
  
  private let roulettePies: [Int] = [7,6,5]
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<CheeseCounter>().rx
  let model: GiftViewModel.Item
  let modelSubject: PublishSubject<RouletteModel> = PublishSubject()
  let colorPalette: [UIColor]
  
  let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "counterGameBg"))
    imageView.contentMode = .center
    return imageView
  }()
  
  let pinView: UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "pointer"))
    return view
  }()
  
  var previousIndex: Int = 0
  var spinWheelControl:SpinWheelControl!
  
  let spinBGView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9787054658, green: 0.8919286728, blue: 0.3518205881, alpha: 1)
    return view
  }()
  
  let threeButton: UIButton = {
    let button = UIButton()
    button.tag = 0
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  let fiveButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  let sevenButton: UIButton = {
    let button = UIButton()
    button.tag = 2
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  let centerIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "invalidName"))
    icon.contentMode = UIViewContentMode.scaleAspectFit
    return icon
  }()
  
  let centerColorView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.8901960784, blue: 0.3529411765, alpha: 1)
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 40
    return view
  }()
  
  let divideView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  let divideView1: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  let rouletteImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "rouletteType"))
  
  let selectedImageButton: [UIButton] = {
    var imageButtons = [UIButton]()
    let button = UIButton()
    let button1 = UIButton()
    let button2 = UIButton()
    button.setImage(#imageLiteral(resourceName: "ic777CheeseD"), for: .normal)
    button1.setImage(#imageLiteral(resourceName: "ic777CheeseD"), for: .normal)
    button2.setImage(#imageLiteral(resourceName: "ic777CheeseD"), for: .normal)
    button.backgroundColor = .white
    button1.backgroundColor = .white
    button2.backgroundColor = .white
    imageButtons.append(button)
    imageButtons.append(button1)
    imageButtons.append(button2)
    return imageButtons
  }()
  
  let choiceImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "777Light").withRenderingMode(.alwaysTemplate))
    imageView.tintColor = .white
    imageView.backgroundColor = #colorLiteral(red: 0.9787054658, green: 0.8919286728, blue: 0.3518205881, alpha: 1)
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    return imageView
  }()

  init(images:[UIImage], model: GiftViewModel.Item) {
    self.images = images
    self.colorPalette = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9175666571, green: 0.9176985621, blue: 0.9175377488, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9175666571, green: 0.9176985621, blue: 0.9175377488, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    UIView.animate(withDuration: 1.5) { [weak self] in
      self?.tabBarController?.tabBar.isHidden = true
      self?.navigationController?.navigationBar.setBackgroundImage(
        UIImage.resizable().color(#colorLiteral(red: 0.9787054658, green: 0.8919286728, blue: 0.3518205881, alpha: 1)).image, for: UIBarMetrics.default)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    UIView.animate(withDuration: 1.5) { [weak self] in
      self?.tabBarController?.tabBar.isHidden = false
      self?.navigationController?.navigationBar.setBackgroundImage(
        UIImage.resizable().color(.white).image, for: UIBarMetrics.default)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    ToastView.appearance().font = UIFont.CheeseFontMedium(size: 15)
    ToastView.appearance().bottomOffsetPortrait = 200
    
    UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
      self.navigationController?.setNavigationBarHidden(false, animated: true)
    }, completion: nil)
    
    let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gameBtnBack"), style: .plain, target: self, action: #selector(backButtonAction))
    self.navigationItem.leftBarButtonItem = backButton
    
    spinWheelControl = SpinWheelControl()
    spinWheelControl.dataSource = self
    spinWheelControl.delegate = self
    spinWheelControl.isUserInteractionEnabled = false
    
    self.view.addSubview(imageView)
    self.view.addSubview(spinWheelControl)
    self.view.addSubview(pinView)
    self.view.addSubview(rouletteImage)
    self.view.insertSubview(spinBGView, belowSubview: spinWheelControl)
    self.view.addSubview(threeButton)
    self.view.addSubview(fiveButton)
    self.view.addSubview(sevenButton)
    self.view.addSubview(choiceImageView)
    self.view.addSubview(centerColorView)
    self.view.addSubview(centerIcon)
    for image in selectedImageButton{
      self.view.addSubview(image)
    }
    self.view.addSubview(divideView)
    self.view.addSubview(divideView1)
    
    self.spinBGView.backgroundColor = .gray
    addConstraint()
    
    provider.request(.getMyPoint)
      .filter(statusCode: 200)
      .map(PointModel.self)
      .map{$0.result.data.cheese}
      .asDriver(onErrorJustReturn: nil)
      .filterNil()
      .map{Int($0)}
      .filterNil()
      .drive(onNext: defaultNavSetting)
      .disposed(by: disposeBag)
    
    
    threeButton.setAttributedTitle(buttonAttribute(text:model.game1Point), for: .normal)
    fiveButton.setAttributedTitle(buttonAttribute(text:model.game2Point), for: .normal)
    sevenButton.setAttributedTitle(buttonAttribute(text:model.game3Point), for: .normal)
    
    let button1 = threeButton.rx
      .tap
      .map{[unowned self] _ in return self.threeButton.tag}
      .share()
    
    let button2 = fiveButton.rx
      .tap
      .map{[unowned self] _ in return self.fiveButton.tag}
      .share()
    
    let button3 = sevenButton.rx
      .tap
      .map{[unowned self] _ in return self.sevenButton.tag}
      .share()
    
    // touch Begin && Game Start??
    let beginGameObserver = Observable.of(button1,button2,button3)
      .merge()
      .do(onNext: { [unowned self] (index) in
        self.currentLevel = index
        ToastCenter.default.cancelAll()
      })
      .flatMap {[unowned self] _ in
        return self.provider.request(.getMyPoint)
          .filter(statusCode: 200)
          .map(PointModel.self)
          .map{$0.result.data.cheese}
      }.filterNil()
      .map{Int($0)}
      .filterNil()
      .map { [unowned self] index in
        return (index > self.levelConverter(index: self.currentLevel),index)
    }.share()
    
    beginGameObserver
      .bind(onNext: navigationSetting)
      .disposed(by: disposeBag)
    
    beginGameObserver
      .filter{$0.0}
      .do(onNext:{_ in Toast(text: "룰렛을 돌려보세요!", delay: 0.2, duration: 1).show()})
      .do(onNext:{[unowned self] _ in
        self.images = self.shuffleIcons(index: self.roulettePies[self.currentLevel])
        self.spinWheelControl.reloadData()
      })
      .bind(onNext: buttonTouch)
      .disposed(by: disposeBag)
    
    spinWheelControl.rx
      .controlEvent(UIControlEvents.touchDown)
      .filter { return !self.userRouletteFirstTouch}
      .do(onNext: { [unowned self] _ in
        self.threeButton.isUserInteractionEnabled = false
        self.fiveButton.isUserInteractionEnabled = false
        self.sevenButton.isUserInteractionEnabled = false
        self.userRouletteFirstTouch = true
      })
      .map{[unowned self] _ in return self.currentLevel}
      .bind(onNext: request)
      .disposed(by: disposeBag)
    
    spinWheelControl.velocitySubject
      .map{abs($0) > 10}
      .subscribe(onNext: {[unowned self] (isStart) in
        if isStart{
          self.gameRun()
          self.startGame = true
          self.spinWheelControl.isUserInteractionEnabled = false
        }else{
          Toast(text: "더 세게 돌려주세요!", delay: 0, duration: 0.5).show()
          self.startGame = false
          self.spinWheelControl.isUserInteractionEnabled = true
        }
      }).disposed(by: disposeBag)
    
    spinWheelControl.rx
      .controlEvent(.valueChanged)
      .map{[unowned self] in
        return self.spinWheelControl.selectedIndex}
      .distinctUntilChanged()
      .filter({[unowned self] _ in
        return self.startGame
      })
      .subscribe(onNext: { [weak self](item) in
        self?.history.append(item)
      }).disposed(by: disposeBag)
    
    spinWheelControl.rx
      .controlEvent(.valueChanged)
      .map{[unowned self] in
        return self.spinWheelControl.selectedIndex}
      .distinctUntilChanged()
      .scan([]) { (previous, current) in
        return Array(previous + [current]).suffix(2)}
      .map {
        $0.first! < $0.last!}
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: {(bool) in
        if bool{
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
          guard let `self` = self else {return}
          self.pinView.transform = CGAffineTransform(rotationAngle: 1)
          }, completion: { (bool) in
            self.pinView.transform = CGAffineTransform(rotationAngle: 0)
        })
        }else{
          UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let `self` = self else {return}
            self.pinView.transform = CGAffineTransform(rotationAngle: -1)
            }, completion: { (bool) in
              self.pinView.transform = CGAffineTransform(rotationAngle: 0)
          })
        }
      })
      .disposed(by: disposeBag)
    
    spinWheelControl.rx
      .controlEvent(.editingDidEnd)
      .do(onNext:{[unowned self] in
        self.spinWheelControl.isUserInteractionEnabled = true
      })
      .bind(onNext: gameStop)
      .disposed(by: disposeBag)
  }
  
  @objc func backButtonAction(){
    let alert = UIAlertController(title: nil, message: "게임을 종료하시겠습니까?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "예", style: .default, handler: { (_) in
      self.navigationController?.popViewController(animated: true)
    }))
    alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func buttonTouch(index: (Bool,Int)){
    
    self.spinWheelControl.isUserInteractionEnabled = true
    self.spinBGView.backgroundColor = #colorLiteral(red: 0.9787054658, green: 0.8919286728, blue: 0.3518205881, alpha: 1)
    switch currentLevel{
    case 0:
      self.threeButton.alpha = 1
      self.fiveButton.alpha = 0.5
      self.sevenButton.alpha = 0.5
    case 1:
      self.threeButton.alpha = 0.5
      self.fiveButton.alpha = 1
      self.sevenButton.alpha = 0.5
    case 2:
      self.threeButton.alpha = 0.5
      self.fiveButton.alpha = 0.5
      self.sevenButton.alpha = 1
    default:
      break
    }
  }
  
  private func buttonAttribute(text: String) -> NSAttributedString{
    let attribute = NSAttributedString(
      string: text+"치즈",
      attributes: [NSAttributedStringKey.font: UIFont.CheeseFontBold(size: 12),
                   NSAttributedStringKey.foregroundColor: UIColor.white,
                   NSAttributedStringKey.strokeColor: UIColor(red: 1.0, green: 0.564, blue: 0.342, alpha: 1.0),
                   NSAttributedStringKey.strokeWidth: 4.5])
    return attribute
  }
  
  private func defaultNavSetting(point: Int){
    let label = UILabel()
    label.numberOfLines = 2
    let attribute = NSMutableAttributedString(
      string: self.model.title+"\n",
      attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 15)])
    attribute.append(NSAttributedString(
      string: "배팅치즈: 0   ",
      attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11)]))
    attribute.append(NSAttributedString(
      string: "보유치즈: \(point.stringFormattedWithSeparator())치즈 ",
      attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11),
                   NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)]))
    label.attributedText = attribute
    self.navigationItem.titleView = label
  }
  
  private func navigationSetting(condition: (Bool,Int)){
    
    let label = UILabel()
    label.numberOfLines = 2

    if condition.0{
      let attribute = NSMutableAttributedString(
        string: self.model.title+"\n",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 15)])
      attribute.append(NSAttributedString(
        string: "배팅치즈: \(levelConverter(index: self.currentLevel))   ",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11)]))
      attribute.append(NSAttributedString(
        string: "보유치즈: \((condition.1 - levelConverter(index: currentLevel)).stringFormattedWithSeparator())치즈 ",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11),
                     NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)]))
      label.attributedText = attribute
    }else{
      let attribute = NSMutableAttributedString(
        string: self.model.title+"\n",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 15)])
      attribute.append(NSAttributedString(
        string: "배팅치즈: \(levelConverter(index: self.currentLevel))   ",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11)]))
      attribute.append(NSAttributedString(
        string: "보유치즈: \(condition.1.stringFormattedWithSeparator())치즈 ",
        attributes: [NSAttributedStringKey.font : UIFont.CheeseFontMedium(size: 11),
                     NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1)]))
      label.attributedText = attribute
      
      let alert = UIAlertController(title: nil, message: "베팅 치즈가 부족합니다", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "치즈 적립하기", style: .default, handler: { [weak self] (_) in
        guard let retainSelf = self else {return}
        retainSelf.tabBarController?.selectedIndex = 0
        retainSelf.navigationController?.popViewController(animated: false)
      }))
      alert.addAction(UIAlertAction(title: "다른 상품 보기", style: .default, handler: {[weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }))
      
      self.present(alert, animated: true, completion: nil)
    }
    navigationItem.titleView = label
  }
  
  private func levelConverter(index: Int) -> Int{
    if index == 0{
      return 30
    }else if index == 1{
      return 50
    }else if index == 2{
      return 75
    }else{
      return 0
    }
  }
  
  private func request(index: Int){
  
    provider.request(.regRoulette(gift_id: model.id, level: "\(index+1)"))
      .map(RouletteModel.self)
      .flatMap {[weak self] (model)  in
        guard let retainSelf = self else {return Single<Response>.error(NSError())}
        return retainSelf.provider
          .request(.getRouletteBoard(id: model.result.data.id ?? ""))}
      .map(RouletteModel.self)
      .asObservable()
      .bind(onNext: gameSetting)
      .disposed(by: disposeBag)
  }
  
  private func updateRequest(id: String, stage: String,re: String, isDone: Bool){
    
    if !isDone{
      provider.request(.updateRouletteRun(id: id, stage: stage, re: re))
        .filter(statusCode: 200)
        .mapJSON()
        .subscribe(onSuccess: { (result) in
          log.info(result)
        }, onError: { (error) in
          log.error(error)
        }).disposed(by: disposeBag)
    }else{
      provider.request(.updateRouletteRun(id: id, stage: stage, re: re))
        .filter(statusCode: 200)
        .flatMap({[weak self] _ in
          guard let retainSelf = self else {return Single<Response>.error(NSError())}
          return  retainSelf.provider.request(.updateRouletteDone(id: retainSelf.gameID))
                    .filter(statusCode: 200)
        })
        .mapJSON()
        .subscribe({[weak self] (event) in
          switch event{
          case .success:
            self?.gameEnd()
          case .error(let error):
            log.error(error)
          }
        }).disposed(by: disposeBag)
    }
  }
  
  private func gameSetting(model: RouletteModel){
    
    guard let pattern1 = model.result.data.pattern1,
      let pattern2 = model.result.data.pattern2,
      let pattern3 = model.result.data.pattern3,
      let id = model.result.data.id
      else {return}
    
    patterns.append(pattern1.split(separator: ","))
    patterns.append(pattern2.split(separator: ","))
    patterns.append(pattern3.split(separator: ","))
    gameID = id
  }
  
  private func gameRun(){
    switch stageStatus{
    case .default:
      stageStatus = .first
    case .first:
      stageStatus = .middle
    case .middle:
      stageStatus = .last
    case .last:
      break
    }
    defer {
      ToastCenter.default.cancelAll()
    }
  }
  
  private func gameStop(){
    guard startGame else {return}
    var temp:[String] = []
    switch stageStatus{
    case .first:
      
      for i in history{
        let char = patterns[0][i]
        temp.append(String(char))
      }
      let re = temp.joined(separator: ",")
      updateRequest(id: self.gameID, stage: "1", re: re, isDone: false)
      self.selectedImageButton[0].setImage(images[spinWheelControl.selectedIndex], for: .normal)
      let vc = GetIconViewController(icon: images[spinWheelControl.selectedIndex],stage: stageStatus)
      vc.modalPresentationStyle = .overCurrentContext
      self.present(vc, animated: true, completion: nil)
      images = shuffleIcons(index: patterns[0].count)
      spinWheelControl.reloadData()
    case .middle:
      for i in history{
        let char = patterns[1][i]
        temp.append(String(char))
      }
      let re = temp.joined(separator: ",")
      updateRequest(id: self.gameID, stage: "2", re: re, isDone: false)
      self.selectedImageButton[1].setImage(images[spinWheelControl.selectedIndex], for: .normal)
      let vc = GetIconViewController(icon: images[spinWheelControl.selectedIndex], stage: stageStatus)
      vc.modalPresentationStyle = .overCurrentContext
      self.present(vc, animated: true, completion: nil)
      images = shuffleIcons(index: patterns[0].count)
      spinWheelControl.reloadData()
    case .last:
      for i in history{
        let char = patterns[2][i]
        temp.append(String(char))
      }
      let re = temp.joined(separator: ",")
      updateRequest(id: self.gameID, stage: "3", re: re, isDone: true)
      self.selectedImageButton[2].setImage(images[spinWheelControl.selectedIndex], for: .normal)
    default:
      break
    }
    defer {
      selectedHistory.append(spinWheelControl.selectedIndex)
      history = []
      startGame = false
    }
  }
  
  private func gameEnd(){
    if Set(selectedHistory).count == 1{
      Observable.just(model.imageURL)
        .filterNil()
        .map({URL(string: $0.getUrlWithEncoding())})
        .filterNil()
        .map({try Data(contentsOf: $0)})
        .map({UIImage(data: $0)})
        .filterNil()
        .subscribe(onNext: {[weak self] image in
          let alertVC = PMAlertController(title: "당첨을 축하합니다!", description: self?.model.title ?? "", image: image, style: .alert)
          alertVC.addAction(PMAlertAction(title: "다른 상품보기", style: .default, action: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
          }))
          alertVC.addAction(PMAlertAction(title: "쿠폰받기", style: .cancel, action: {
            log.info("쿠폰받기")
          }))
          self?.present(alertVC, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }else{
      let vc = GetIconViewController(icon: images[spinWheelControl.selectedIndex],stage: stageStatus)
      vc.modalPresentationStyle = .overCurrentContext
      vc.dismissAction = {[weak self] in
        let alert = UIAlertController(title: nil, message: "아쉽게도, 이번판은 \n 당첨되지 않았습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "재도전 하기", style: .default, handler: {[weak self] (action) in
          guard let retainSelf = self else {return}
          retainSelf.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "다른 상품 보기", style: .default, handler: {[weak self] _ in
          self?.navigationController?.popViewController(animated: true)
        }))
        self?.present(alert, animated: true, completion: nil)
      }
      self.present(vc, animated: true, completion: nil)
    }
  }
  
  private func shuffleIcons(index: Int) -> [UIImage]{
    var items = [UIImage]()
    
    if !startGame{
      let tempArray = NSArray(array: cheeseIcons, copyItems: true).shuffled() as NSArray
      selectedImages = tempArray.subarray(with: NSRange(location: 0, length: index)) as NSArray
      selectedImages = selectedImages.shuffled() as NSArray
    }else{
      selectedImages = selectedImages.shuffled() as NSArray
    }
    
    for i in 0..<index
    {
      items.append(selectedImages[i] as! UIImage)
    }
    return items
  }
  
  private func reloadData(){
    spinWheelControl.isUserInteractionEnabled = false
    spinBGView.backgroundColor = .lightGray
    patterns = []
    images = [#imageLiteral(resourceName: "cheeseBrie"),#imageLiteral(resourceName: "cheeseFeta"),#imageLiteral(resourceName: "cheeseBrick"),#imageLiteral(resourceName: "cheeseGauda"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseBrie2")]
    startGame = false
    history = []
    currentLevel = 0
    selectedImages = []
    threeButton.isUserInteractionEnabled = true
    fiveButton.isUserInteractionEnabled = true
    sevenButton.isUserInteractionEnabled = true
    
    threeButton.alpha = 1
    fiveButton.alpha = 1
    sevenButton.alpha = 1
    
    userRouletteFirstTouch = false
    isPresentingForFirstTime = false
    isPopViewControllerAgree  = false
    
    stageStatus  = .default
    request(index: currentLevel)
    
    self.spinWheelControl.reloadData()
    for button in selectedImageButton{
      button.setImage(#imageLiteral(resourceName: "ic777CheeseD"), for: .normal)
    }
  }
  
  private func addConstraint(){
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    spinWheelControl.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(51.5)
      make.left.equalToSuperview().inset(35)
      make.right.equalToSuperview().inset(35)
      make.height.equalTo(spinWheelControl.snp.width)
    }
    
    spinBGView.snp.makeConstraints { (make) in
      make.edges.equalTo(spinWheelControl).inset(UIEdgeInsets(top: -14, left: -14, bottom: -14, right: -14))
    }
    
    pinView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(spinBGView.snp.top).inset(5)
      make.height.equalTo(24.5)
      make.width.equalTo(13)
    }
    
    choiceImageView.snp.makeConstraints { (make) in
      make.top.equalTo(spinBGView.snp.bottom).offset(45.5)
      make.left.equalToSuperview().inset(78.5)
      make.right.equalToSuperview().inset(78.5)
      make.height.equalTo(75)
    }
    
    fiveButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(27)
      make.height.equalTo(42)
      make.width.equalTo(98)
    }
    
    threeButton.snp.makeConstraints { (make) in
      make.height.equalTo(fiveButton)
      make.width.equalTo(fiveButton)
      make.centerY.equalTo(fiveButton)
      make.right.equalTo(fiveButton.snp.left).offset(-5.5)
    }
    
    sevenButton.snp.makeConstraints { (make) in
      make.height.equalTo(fiveButton)
      make.width.equalTo(fiveButton)
      make.centerY.equalTo(fiveButton)
      make.left.equalTo(fiveButton.snp.right).offset(5.5)
    }
    
    selectedImageButton[1].snp.makeConstraints { (make) in
      make.centerX.equalTo(choiceImageView)
      make.top.equalTo(choiceImageView).inset(8)
      make.bottom.equalTo(choiceImageView).inset(8)
      make.width.equalTo(selectedImageButton[1].snp.height)
    }
    
    selectedImageButton[0].snp.makeConstraints { (make) in
      make.left.equalTo(choiceImageView).inset(9)
      make.top.equalTo(choiceImageView).inset(8)
      make.bottom.equalTo(choiceImageView).inset(8)
      make.right.equalTo(selectedImageButton[1].snp.left)
    }
    
    selectedImageButton[2].snp.makeConstraints { (make) in
      make.left.equalTo(selectedImageButton[1].snp.right)
      make.bottom.equalTo(choiceImageView).inset(8)
      make.top.equalTo(choiceImageView).inset(8)
      make.right.equalTo(choiceImageView).inset(9)
    }
    
    rouletteImage.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(49)
      make.top.equalToSuperview().inset(26)
      make.width.equalTo(100)
      make.height.equalTo(60)
    }
    
    centerColorView.snp.makeConstraints { (make) in
      make.center.equalTo(spinWheelControl)
      make.height.equalTo(80)
      make.width.equalTo(80)
    }
    
    centerIcon.snp.makeConstraints { (make) in
      make.center.equalTo(spinWheelControl)
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
    
    divideView.snp.makeConstraints { (make) in
      make.top.equalTo(selectedImageButton[0])
      make.left.equalTo(selectedImageButton[0].snp.right).offset(-2)
      make.width.equalTo(2)
      make.bottom.equalTo(selectedImageButton[0])
    }
    
    divideView1.snp.makeConstraints { (make) in
      make.top.equalTo(selectedImageButton[1])
      make.left.equalTo(selectedImageButton[1].snp.right).offset(2)
      make.width.equalTo(2)
      make.bottom.equalTo(selectedImageButton[1])
    }
  }
  
  func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
    let wedge = SpinWheelWedge()
    wedge.shape.fillColor = colorPalette[Int(index)].cgColor
    wedge.image.image = images[Int(index)]
    wedge.point.image = #imageLiteral(resourceName: "light1").withRenderingMode(.alwaysTemplate)
    wedge.point.tintColor = .white
    
    return wedge
  }
  
  override func viewDidLayoutSubviews() {
    spinBGView.layer.cornerRadius = spinBGView.frame.size.width/2
    spinBGView.layer.masksToBounds = true
  }
  
  override func viewDidAppear(_ animated: Bool) {

    if !isPresentingForFirstTime{
      
      spinWheelControl.reloadData()
      
      let message = """
직접 룰렛을 돌려 경품을 얻어가세요!

3번 모두 같은 치즈 캐릭터가 나오면
경품을 얻어 가실 수 있습니다!

더 높은 치즈를 배팅할 수록
당첨될 확률은 높아집니다.

예) 75치즈 배팅 -> 5칸의 판
50치즈 배팅 -> 6칸의 판
30치즈 배팅 -> 7칸의 판
"""
      
      let alertView = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alertView.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      self.present(alertView, animated: true, completion: nil)
      isPresentingForFirstTime = true
    }
  }
  
  func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
    return UInt(self.images.count)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


