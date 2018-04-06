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
import CryptoSwift

enum StageStatus: Int{
  case first = 1
  case middle = 2
  case last = 3
  case `default` = 0
}

class GameViewController: UIViewController , SpinWheelControlDataSource, SpinWheelControlDelegate {
  
  private let cheeseIcons = ["a":#imageLiteral(resourceName: "cheeseEmental"),"b":#imageLiteral(resourceName: "cheeseGorgonzola"),"c":#imageLiteral(resourceName: "cheeseBrie2"),"d":#imageLiteral(resourceName: "cheeseColbyjack"),"e":#imageLiteral(resourceName: "cheeseGauda"),"f":#imageLiteral(resourceName: "cheeseHavati"),"g":#imageLiteral(resourceName: "cheeseBrick")]
  
  private var userRouletteFirstTouch: Bool = false
  private var images: [UIImage]
  private var isPresentingForFirstTime: Bool = false
  
  private var isPopViewControllerAgree: Bool = false
  private var patterns:[Array<Substring>] = []
  private var stageStatus: StageStatus = .default
  private var gameID = ""
  
  /// 게임이 시작이 되었는지 판단
  private var startGame: Bool = false
  private var pointModel: PointModel?
  
  private var history: [Int] = []
  private var selectedHistory: [Int] = []
  private var currentLevel: Int = 0
  private var selectedImages: NSArray = []
  
  private let roulettePies: [Int] = [7,6,5]
  private let disposeBag = DisposeBag()
  let provider = CheeseService.provider
  private let model: GiftViewModel.Item
  private let modelSubject: PublishSubject<RouletteModel> = PublishSubject()
  private let colorPalette: [UIColor]
  
  private let pointShare = CheeseService
    .provider
    .request(.getMyPoint)
    .filter(statusCode: 200)
    .asObservable()
    .share()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "counterGameBg"))
    imageView.contentMode = .center
    return imageView
  }()
  
  private let pinView: UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "pointer"))
    return view
  }()
  
  private var previousIndex: Int = 0
  private lazy var spinWheelControl: SpinWheelControl = {
    let spinWheel = SpinWheelControl()
    spinWheel.dataSource = self
    spinWheel.delegate = self
    spinWheel.isUserInteractionEnabled = false
    return spinWheel
  }()
  
  private let spinBGView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9787054658, green: 0.8919286728, blue: 0.3518205881, alpha: 1)
    return view
  }()
  
  private let threeButton: UIButton = {
    let button = UIButton()
    button.tag = 0
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  private let fiveButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  private let sevenButton: UIButton = {
    let button = UIButton()
    button.tag = 2
    button.setBackgroundImage(#imageLiteral(resourceName: "btnBattingCheese"), for: .normal)
    return button
  }()
  
  private let centerIcon: UIImageView = {
    let icon = UIImageView(image: #imageLiteral(resourceName: "invalidName"))
    icon.contentMode = UIViewContentMode.scaleAspectFit
    return icon
  }()
  
  private let centerColorView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.8901960784, blue: 0.3529411765, alpha: 1)
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 40
    return view
  }()
  
  private let divideView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let divideView1: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let rouletteImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "rouletteType"))
  
  private let selectedImageButton: [UIButton] = {
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
  
  private let choiceImageView: UIImageView = {
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
  
  override func loadView() {
    super.loadView()
    UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
      self.navigationController?.setNavigationBarHidden(false, animated: true)
    }, completion: nil)
    
    let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gameBtnBack"), style: .plain, target: self, action: #selector(backButtonAction))
    self.navigationItem.leftBarButtonItem = backButton
    
   
    ToastView.appearance().font = UIFont.CheeseFontMedium(size: 15)
    ToastView.appearance().bottomOffsetPortrait = 200
    self.view.addSubview(imageView)
    self.view.addSubview(rouletteImage)
    self.view.addSubview(spinWheelControl)
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
    self.view.addSubview(pinView)
    
    addConstraint()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pointShare
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
    
    // 게임 시작전 버튼 클릭
    let beginGameObserver = Observable.of(button1,button2,button3)
      .merge()
    
    beginGameObserver
      .do(onNext: { [unowned self] (index) in
        self.currentLevel = index
        ToastCenter.default.cancelAll()
      })
      .flatMap {[unowned self] _ in
        self.pointShare
          .map(PointModel.self)
          .map{$0.result.data.cheese}
      }.filterNil()
      .map{Int($0)}
      .filterNil()
      .map { [unowned self] index in
        return (index > self.levelConverter(index: self.currentLevel),index)
      }.bind(onNext: navigationSetting)
      .disposed(by: disposeBag)
    
    beginGameObserver
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
          self.spinWheelControl.reloadRotate()
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
  
  private func buttonTouch(){
    
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
      return Int(model.game1Point) ?? 0
    }else if index == 1{
      return Int(model.game2Point) ?? 0
    }else if index == 2{
      return Int(model.game3Point) ?? 0
    }else{
      return 0
    }
  }
  
  private func request(index: Int){
    CheeseService.provider.request(.regRoulette(gift_id: model.id, level: "\(index+1)"))
      .filter(statusCode: 200)
      .map(RouletteModel.self)
      .do(onSuccess: { (_) in
        self.threeButton.isUserInteractionEnabled = false
        self.fiveButton.isUserInteractionEnabled = false
        self.sevenButton.isUserInteractionEnabled = false
        self.userRouletteFirstTouch = true
        self.buttonTouch()
      })
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
    guard let result = cryptoGenerate(of: re) else {return}
    if !isDone{
      provider.request(.updateRouletteRun(id: id, stage: stage, re: result))
        .filter(statusCode: 200)
        .mapJSON()
        .subscribe(onSuccess: { (result) in
        }, onError: { (error) in
          log.error(error)
        }).disposed(by: disposeBag)
    }else{
      provider.request(.updateRouletteRun(id: id, stage: stage, re: result))
        .filter(statusCode: 200)
        .flatMap({[weak self] _ in
          guard let retainSelf = self else {return Single<Response>.error(NSError())}
          return  retainSelf.provider.request(.updateRouletteDone(id: retainSelf.gameID))
                    .filter(statusCode: 200)
        })
        .mapJSON()
        .map{JSON($0)}
        .asObservable()
        .bind(onNext: gameEnd)
        .disposed(by: disposeBag)
    }
  }
  
  /// 암호화 (AES)
  ///
  /// - Parameter data: 암호화 대상
  /// - Returns: 암호화 결과
  private func cryptoGenerate(of data: String) -> String?{
    let key = "xiilabxiilabxiilabxiilabxiilabxi"
    let index = key.index(key.startIndex, offsetBy: 16)
    let initVector = String(key[..<index])
    do{
      let result = try AES(key: key, iv: initVector, padding: .pkcs7).encrypt(Array(data.utf8))
      return result.toHexString()
    }catch let error{
      return nil
    }
    
//    do{
//      let aes = try AES(key: Array(key), blockMode: .CBC(iv: Array(iv)), padding: .pkcs7).encrypt(Array(data.utf8))
//
//      log.info(aes)
//    }catch {}
//    do{
//      let aes = try AES(key: key, iv: String(key[..<index]))
//      let result = try? data.encrypt(cipher: aes)
//      log.info(result)
//
//    }catch let error{
//      log.error(error)
//    }
  }
  
  /// 스테이지당 이미지 셔플 및 세팅
  private func imagesSetting(stage: Int){
    var tempImages:[UIImage] = []
    for i in patterns[stage]{
      tempImages.append(cheeseIcons[String(i),default: UIImage()])
    }
    images = tempImages
    spinWheelControl.reloadData()
  }
  
  
  /// 게임 초기 세팅
  ///
  /// - Parameter model: 룰렛 모델
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
    
    imagesSetting(stage: 0)
    Toast(text: "룰렛을 돌려보세요!", delay: 0.2, duration: 1).show()
  }
  
  
  /// 게임 시작
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
  
  
  /// 스테이지 종료
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
      imagesSetting(stage: 1)
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
      imagesSetting(stage: 2)
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
  
  /// 게임종료
  ///
  /// - Parameter json: 게임결과 
  private func gameEnd(json: JSON){
    
    if json["result"]["data"].stringValue == "아쉽지만 다음 기회에...."{
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
    }else{
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
          alertVC.addAction(PMAlertAction(title: "쿠폰받기", style: .cancel, action: {[weak self] in
            guard let `self` = self else {return}
            let navigation = self.navigationController
            navigation?.popViewController(animated: true)
            navigation?.present(MypageNaviViewController(), animated: true, completion: nil)
          }))
          self?.present(alertVC, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
  }

  
  private func reloadData(){
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
    
    spinWheelControl.isUserInteractionEnabled = false
    spinBGView.backgroundColor = .lightGray
    patterns = []
    images = [#imageLiteral(resourceName: "cheeseEmental"),#imageLiteral(resourceName: "cheeseGorgonzola"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseColbyjack"),#imageLiteral(resourceName: "cheeseGauda"),#imageLiteral(resourceName: "cheeseHavati"),#imageLiteral(resourceName: "cheeseBrick")]
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
    
//    fiveButton.snp.makeConstraints { (make) in
//      make.centerX.equalToSuperview()
//      make.bottom.equalToSuperview().inset(27)
//      make.height.equalTo(42)
//      make.width.equalTo(98)
//    }
//
//    threeButton.snp.makeConstraints { (make) in
//      make.height.equalTo(fiveButton)
//      make.width.equalTo(fiveButton)
//      make.centerY.equalTo(fiveButton)
//      make.right.equalTo(fiveButton.snp.left).offset(-5.5)
//    }
//
//    sevenButton.snp.makeConstraints { (make) in
//      make.height.equalTo(fiveButton)
//      make.width.equalTo(fiveButton)
//      make.centerY.equalTo(fiveButton)
//      make.left.equalTo(fiveButton.snp.right).offset(5.5)
//    }
    
    constraintFromServer()
    
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
    spinWheelControl.reloadData()
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

\(alertCheeseString())
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
  
  private func constraintFromServer(){
    var buttons = [UIButton]()
    if model.game1Point != "999999"{
      buttons.append(threeButton)
    }else{
      threeButton.removeFromSuperview()
    }
    
    if model.game2Point != "999999"{
      buttons.append(fiveButton)
    }else{
      fiveButton.removeFromSuperview()
    }
    
    if model.game3Point != "999999"{
      buttons.append(sevenButton)
    }else{
      sevenButton.removeFromSuperview()
    }
    
    buttonConstraint(buttons: buttons)
  }
  
  private func buttonConstraint(buttons: [UIButton]){
    switch buttons.count{
    case 1:
      buttons[0].snp.makeConstraints({ (make) in
        make.centerX.equalToSuperview()
        make.height.equalTo(42)
        make.width.equalTo(98)
        make.bottom.equalToSuperview().inset(27)
      })
    case 2:
      buttons[0].snp.makeConstraints({ (make) in
        make.right.equalTo(self.view.snp.centerX).inset(-10)
        make.height.equalTo(42)
        make.width.equalTo(98)
        make.bottom.equalToSuperview().inset(27)
      })
      
      buttons[1].snp.makeConstraints({ (make) in
        make.left.equalTo(self.view.snp.centerX).offset(10)
        make.height.equalTo(buttons[0])
        make.width.equalTo(buttons[0])
        make.bottom.equalTo(buttons[0])
      })
    case 3:
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
    default:
      break
    }
  }
  
  private func alertCheeseString() -> String{
    var temp = String()
    
    if model.game1Point != "999999"{
      temp.append("\(model.game1Point)치즈 배팅 -> 7칸의 판\n")
    }
    
    if model.game2Point != "999999"{
      temp.append("\(model.game2Point)치즈 배팅 -> 6칸의 판\n")
    }
    
    if model.game3Point != "999999"{
      temp.append("\(model.game3Point)치즈 배팅 -> 5칸의 판")
    }
    
    return temp
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


