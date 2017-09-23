//
//  CheeseSelectedViewController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//  2번째 페이지 선택창

import UIKit

import URLNavigator
import Spring

enum isclick: Int {
  case True
  case False
}

final class CheeseSelectedViewController: UIViewController
{
  
  let activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    activityView.activityIndicatorViewStyle = .gray
    activityView.startAnimating()
    return activityView
  }()
  
  var didTap:(()->Void)?
  
  var cheeseData: CheeseResultByDate.Data?{
    didSet{
      fetch()
    }
  }

  var openData: OpenData
  
  //MARK: - UI
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 19)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.lineBreakMode = .byTruncatingTail
    label.backgroundColor = .clear
    return label
  }()
  
  let divideLine: UIView = {
    let line = UIView()
    line.backgroundColor = .lightGray
    return line
  }()
  
  lazy var imageViews: [SelectImageView] = {
    var imgViews = [SelectImageView]()
    for i in 0...3 {
      let imgView = SelectImageView(frame: .zero)
      let tap = UITapGestureRecognizer(target: self,
                                       action: #selector(pushResultPage(_:)))
      tap.numberOfTapsRequired = 1
      imgView.contentMode = .scaleAspectFill
      imgView.layer.masksToBounds = true
      imgView.addGestureRecognizer(tap)
      imgView.isUserInteractionEnabled = true
      imgView.tag = i+1
      imgViews.append(imgView)
    }
    return imgViews
  }()
  
  init(openData: OpenData){
    self.openData = openData
    self.cheeseData = openData.data
    super.init(nibName: nil, bundle: nil)
    self.runWithCheck(openData: openData)
  }

  init(){
    self.openData = OpenData(openType: .normal, data: nil, isLogin: true)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.cheeseColor()
    view.addSubview(titleLabel)
    view.addSubview(divideLine)
    self.navigationItem.title = "오늘의 질문"
    
    // textView의 상단의 빈공간이 생기는 이유로 삽입
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addConstraint()
  }
  
  func addConstraint(){
    
    let width = self.view.frame.width / 2
    
    guard let type = cheeseData?.type else { return }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.snp.topMargin).inset(10)
      make.left.equalTo(self.view.snp.leftMargin).inset(10)
      make.right.equalTo(self.view.snp.rightMargin).inset(10)
      make.height.equalTo(40)
      make.bottom.equalTo(divideLine.snp.top).offset(-10)
    }
    
    if type == "2"{
      self.view.addSubview(imageViews[0])
      self.view.addSubview(imageViews[1])
      divideLine.snp.remakeConstraints { (make) in
        make.left.equalTo(view.snp.leftMargin).inset(10)
        make.right.equalTo(view.snp.rightMargin).inset(10)
        make.height.equalTo(0.5)
      }
      
      imageViews[0].snp.remakeConstraints({ (make) in
        make.left.equalTo(divideLine)
        make.right.equalTo(divideLine)
        make.top.equalTo(divideLine.snp.bottom).offset(20)
        make.height.lessThanOrEqualTo(width * 1.1)
      })
      
      imageViews[1].snp.remakeConstraints({ (make) in
        make.top.equalTo(imageViews[0].snp.bottom).offset(20)
        make.right.equalTo(divideLine)
        make.left.equalTo(divideLine)
        make.height.equalTo(imageViews[0])
        make.bottom.equalToSuperview().inset(20).priority(998)
      })
      
      imageViews[2].removeFromSuperview()
      imageViews[3].removeFromSuperview()
    } else {
      self.view.addSubview(imageViews[0])
      self.view.addSubview(imageViews[1])
      self.view.addSubview(imageViews[2])
      self.view.addSubview(imageViews[3])
      divideLine.snp.remakeConstraints { (make) in
        make.left.equalTo(view.snp.leftMargin)
        make.right.equalTo(view.snp.rightMargin)
        make.height.equalTo(0.5)
      }
      
      imageViews[0].snp.remakeConstraints { (make) in
        make.top.equalTo(titleLabel.snp.bottom).offset(20)
        make.left.equalTo(view.snp.leftMargin)
        make.width.equalTo(width * 0.9)
        make.height.lessThanOrEqualTo(width * 1.1)
      }
      
      imageViews[1].snp.remakeConstraints { (make) in
        make.top.equalTo(imageViews[0])
        make.right.equalTo(view.snp.rightMargin)
        make.width.equalTo(width * 0.9)
        make.height.equalTo(imageViews[0])
      }
      
      imageViews[2].snp.remakeConstraints { (make) in
        make.top.equalTo(imageViews[0].snp.bottom).offset(6)
        make.left.equalTo(imageViews[0])
        make.width.equalTo(imageViews[0])
        make.height.equalTo(imageViews[0])
        make.bottom.equalToSuperview().inset(20).priority(999)
      }
      
      imageViews[3].snp.remakeConstraints { (make) in
        make.top.equalTo(imageViews[2])
        make.right.equalTo(imageViews[1])
        make.height.equalTo(imageViews[1])
        make.width.equalTo(imageViews[1])
      }
    }
  }
  
  deinit {
    log.error("selectVC deinit")
  }
  
  func fetch(){
    self.titleLabel.text = cheeseData?.title
    guard let imgurl1 = cheeseData?.ask1_img_url else { return }
    guard let imgurl2 = cheeseData?.ask2_img_url else { return }
    
    guard let type = cheeseData?.type else { return }
    let url1 = URL(string: imgurl1.getUrlWithEncoding())
    let url2 = URL(string: imgurl2.getUrlWithEncoding())
    
    if type == "2"{
      self.imageViews[0].kf.setImage(with: url1)
      self.imageViews[0].titleLabel.text = cheeseData?.ask1 ?? ""
      self.imageViews[1].kf.setImage(with: url2)
      self.imageViews[1].titleLabel.text = cheeseData?.ask2 ?? ""
    } else {
      guard let imgurl3 = cheeseData?.ask3_img_url else { return }
      guard let imgurl4 = cheeseData?.ask4_img_url else { return }
      
      let url1 = URL(string: imgurl1.getUrlWithEncoding())
      let url2 = URL(string: imgurl2.getUrlWithEncoding())
      let url3 = URL(string: imgurl3.getUrlWithEncoding())
      let url4 = URL(string: imgurl4.getUrlWithEncoding())
      
      self.imageViews[0].kf.setImage(with: url1)
      self.imageViews[0].titleLabel.text = cheeseData?.ask1 ?? ""
      self.imageViews[1].kf.setImage(with: url2)
      self.imageViews[1].titleLabel.text = cheeseData?.ask2 ?? ""
      self.imageViews[2].kf.setImage(with: url3)
      self.imageViews[2].titleLabel.text = cheeseData?.ask3 ?? ""
      self.imageViews[3].kf.setImage(with: url4)
      self.imageViews[3].titleLabel.text = cheeseData?.ask4 ?? ""
    }
  }
  /// 이미지 클릭시 이벤트 발생
  func pushResultPage(_ sender: UITapGestureRecognizer){
    if !openData.isLogin{
      self.navigationController?.dismiss(animated: true, completion: { 
        AlertView(title: "알림", message: "설문에 응답하시려면\n 로그인 해주세요😁", preferredStyle: .alert)
          .addChildAction(title: "확인", style: .default, handeler: nil)
          .show()
      })
      return
    }
    self.view.addSubview(activityView)
    sender.view?.isUserInteractionEnabled = false
    if let view = sender.view{
      let checkImg = UIImageView(image: #imageLiteral(resourceName: "img_select@1x"))
      checkImg.contentMode = .scaleAspectFill
      sender.view?.addSubview(checkImg)
      checkImg.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    let id = cheeseData?.id ?? ""
    CheeseService.insetSurveyResult(surveyId: id, select: sender.view?.tag ?? 0) { [weak self] (result) in
      guard let `self` = self else {return}
      if result == "200"{
        if self.didTap != nil {
          self.didTap!()
        }
        
        self.activityView.stopAnimating()
        let cheeseResultVC = CheeseResultViewController()
        if var totalCount = Int(self.cheeseData?.total_count ?? "0") {
          totalCount += 1
          self.cheeseData?.total_count = "\(totalCount)"
        }
        
        let gifVC = GifViewController()
        cheeseResultVC.cheeseData = self.cheeseData
        if (self.cheeseData?.is_option ?? "0") == "0"{
          gifVC.imageType = .cheese
        }else {
          gifVC.imageType = .gold
        }
        gifVC.modalPresentationStyle = .overCurrentContext
        gifVC.modalTransitionStyle = .flipHorizontal
        gifVC.dismissCompleteAction = {
          self.navigationController?.pushViewController(cheeseResultVC, animated: true)
        }
        
        self.present(gifVC, animated: true, completion: nil)
      }
    }
  }
}

class SelectImageView: UIImageView{
  
  let gradationView: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(gradationView)
    addSubview(titleLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradationView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalToSuperview().dividedBy(3)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.centerY.equalTo(gradationView)
    }
    
    let layer = CAGradientLayer()
    layer.frame = gradationView.bounds
    layer.startPoint = CGPoint(x: 0, y: 1)
    layer.endPoint = CGPoint(x: 0, y: 0)
    layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    gradationView.layer.addSublayer(layer)
  }
}

// MARK: URL을 이용한 뷰컨트롤러 push상황
extension CheeseSelectedViewController{
  func runWithCheck(openData: OpenData){
    
    guard let surveyId = openData.data?.id else {return}
    switch openData.openType {
    case .url(let isEnd):
      if openData.isLogin{
        CheeseService.checkSurveyResult(surveyId: surveyId) {[weak self] (result) in
          guard let `self` = self else{return}
          if result == 1 && isEnd{
            let cheeseResultVC = CheeseResultViewController(openData: openData)
            self.navigationController?.pushViewController(cheeseResultVC, animated: true)
          }
        }
      }else{
        
      }
    case .normal:
      return
    case .search:
      return
    }

  }
}

