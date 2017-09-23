//
//  CheeseResultViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 28..
//  Copyright © 2017년 xiilab. All rights reserved.
//  CheeseResultOtherViewController 와 코드중복

import UIKit

import SnapKit
import XLActionController
import FirebaseDynamicLinks
import KakaoLink
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

class CheeseResultViewController: CheeseBaseViewController {
  
  var cheeseData: CheeseResultByDate.Data?{
    didSet{
      fetchData()
    }
  }
  
  var openData: OpenData
  
  var resultData: [SurveyResult.Data] = []{
    didSet{
      calculateRank(datas: resultData)
      self.collectionView.reloadData()
    }
  }
  
  let activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    activityView.activityIndicatorViewStyle = .gray
    activityView.startAnimating()
    return activityView
  }()

  private(set) lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(self.refreshControlDidChangeValue), for: .valueChanged)
    return refresh
  }()
  
  var topRankSurveyData: SurveyResult.Data?
  var totalCount = 0
  
  init(openData: OpenData) {
    self.openData = openData
    self.cheeseData = openData.data
    super.init(nibName: nil, bundle: nil)
    self.fetchData()
  }
  
  init() {
    self.openData = OpenData(openType: .normal, data: nil, isLogin: true)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setUp(){
    
    self.navigationItem.title = "결과보기"
    self.collectionView.addSubview(refreshControl)
    collectionView.register(CheeseResultViewCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: CheeseResultViewCell.self))
    
    collectionView.register(RereplyViewCell.self, forCellWithReuseIdentifier: String(describing: RereplyViewCell.self))
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "header_home@1x").withRenderingMode(.alwaysTemplate)
      ,style: .plain
      ,target: self
      ,action: #selector(backButtonAction))
    barButton.tintColor = .black
    
    let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "header_share").withRenderingMode(.alwaysOriginal),
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareAction))
    
    self.navigationItem.leftBarButtonItem = barButton
    self.navigationItem.rightBarButtonItem = shareButton
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(keyBoardDown))
    
    collectionView.addGestureRecognizer(gesture)
  }
  
  func backButtonAction(){
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  fileprivate dynamic func shareAction(){
    let actionSheet = TwitterActionController()
    actionSheet.headerData = "공유하기"
    
    actionSheet.addAction(Action(
      ActionData(title: "카카오톡 공유", image: #imageLiteral(resourceName: "share_kakao@1x")),
      style: .default,
      handler: { [weak self] action in
        guard let `self` = self else {return}
        if let view = self.collectionView.supplementaryView(
          forElementKind: UICollectionElementKindSectionHeader,
          at: IndexPath(row: 0, section: 0)) as? CheeseResultViewCell{
          
          let title = view.titleLabel.text ?? ""
          let tag = view.mainView.hashTagLabel.text ?? ""
          guard let imgURL = URL(string: self.cheeseData?.main_img_url?.getUrlWithEncoding() ?? "") else {return}
          self.dynamicLinks(surveyId: self.cheeseData?.id ?? "0", title: title, imageURL: imgURL){[weak self](url) in
            guard let url = url,let `self` = self else {return}
            ShareController.shareAction(
              title: title,
              tag: tag,
              imageURL: imgURL,
              webURL: url,
              surveyId: self.cheeseData?.id ?? "0",
              likeCount: 0,
              commnentCount: 0
            )
          }
        }
    }))
    
    actionSheet.addAction(Action(
      ActionData(title: "페이스북 공유", image: #imageLiteral(resourceName: "share_facebook@1x")),
      style: .default,
      handler: {[weak self] action in
        
        guard let `self` = self else {return}
        if let view = self.collectionView.supplementaryView(
          forElementKind: UICollectionElementKindSectionHeader,
          at: IndexPath(row: 0, section: 0)) as? CheeseResultViewCell{
          
          let title = self.cheeseData?.title ?? ""
          let tag = view.mainView.hashTagLabel.text ?? ""
          guard let imgURL = URL(string: self.cheeseData?.main_img_url?.getUrlWithEncoding() ?? "") else {return}
          self.dynamicLinks(surveyId: self.cheeseData?.id ?? "0", title: title, imageURL: imgURL){[weak self](url) in
            guard let `self` = self , let url = url else {return}
            ShareController.fbShareAction(contentURL: url, hashTag: tag, fromViewController: self)
          }
        }
    }))
    
    actionSheet.addAction(Action(
      ActionData(title: "카카오스토리 공유",
                 image: #imageLiteral(resourceName: "share_kakaostory@1x")),
      style: .default,
      handler: { [weak self] action in
        guard let `self` = self else {return}
        self.view.addSubview(self.activityView)
        
        KOSessionTask.storyIsStoryUserTask(completionHandler: {(isStoryUser, error) in
          if error == nil{
            self.kakaoStoryLink()
          }else {
            log.error(error?.localizedDescription ?? "")
          }
        })
    }))
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  private func kakaoStoryLink(){
    
    if let view = self.collectionView.supplementaryView(
      forElementKind: UICollectionElementKindSectionHeader,
      at: IndexPath(row: 0, section: 0)) as? CheeseResultViewCell{
      guard let imgURL = URL(string: self.cheeseData?.main_img_url?.getUrlWithEncoding() ?? "") else {return}
      let title = view.titleLabel.text ?? ""
      self.dynamicLinks(surveyId: self.cheeseData?.id ?? "0", title: title, imageURL: imgURL){(url) in
        guard let url = url else {return}
        KOSessionTask.storyGetLinkInfoTask(withUrl: url.absoluteString, completionHandler: { (link, error) in
          if error == nil {
            KOSessionTask.storyPostLinkTask(with: link,
                                            content: title,
                                            permission: KOStoryPostPermission.public,
                                            sharable: true,
                                            androidExecParam: nil,
                                            iosExecParam: nil,
                                            completionHandler: { [weak self](post, error) in
                                              if error == nil, let `self` = self {
                                                self.activityView.removeFromSuperview()
                                                AlertView(title: "공유하기 성공").addChildAction(title: "확인", style: .default, handeler: nil).show()
                                              }else {
                                                log.error(error!)
                                              }
            })
          }else {
            log.error(error!)
          }
        })
      }
    }
  }
  
  private func kakaoStoryLogin(){
    KOSessionTask.storyProfileTask { (profile, error) in
      if error != nil {
        
      }else {
        log.error(error?.localizedDescription)
      }
    }
  }
  
  private func dynamicLinks(surveyId: String,title: String, imageURL: URL,_ completion: @escaping (URL?)->Void){
    
    let components = DynamicLinkComponents(
      link: URL(string: "https://www.cheesecounter.co.kr/cheese?kWGPa9nW=\(surveyId)")!,
      domain: "x3exr.app.goo.gl"
    )
    
    let iosParams = DynamicLinkIOSParameters(bundleID: "com.xiilab.CheeseCounter")
    iosParams.appStoreID = "1235147317"
    iosParams.customScheme = "cheesecounter://kWGPa9nW=\(surveyId)"
    iosParams.fallbackURL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1235147317&mt=8")
    iosParams.minimumAppVersion = "1.0.2"
    
    let androidParams = DynamicLinkAndroidParameters(packageName: "com.xiilab.servicedev.cheesecounter")
    androidParams.fallbackURL = URL(string: "https://play.google.com/store/apps/details?id=com.xiilab.servicedev.cheesecounter")
    androidParams.minimumVersion = 6
    
    let socialParams = DynamicLinkSocialMetaTagParameters()
    socialParams.title = title
    socialParams.descriptionText = "세상을 바꾸기 위한 당신의 선택!"
    socialParams.imageURL = imageURL
    
    components.iOSParameters = iosParams
    components.androidParameters = androidParams
    components.socialMetaTagParameters = socialParams
    
    
    components.shorten { (url, _, error) in
      if error == nil{
        completion(url)
      }else {
        completion(nil)
      }
    }
  }
  
  func calculateRank(datas: [SurveyResult.Data]){
    
    var count = 0
    let data = datas.flatMap {
      Int($0.count ?? "")
    }
    
    count = data.reduce(count) { $0 + $1 }
    datas.forEach { (data) in
      if topRankSurveyData != nil{
        topRankSurveyData =
          (Int(topRankSurveyData?.count ?? "") ?? 0) >= (Int(data.count ?? "") ?? 0)
          ? topRankSurveyData
          : data
      } else {
        topRankSurveyData = data
      }
    }
    
    if cheeseData?.is_option == "0" {
      self.totalCount = count
    } else {
      self.totalCount = Int(cheeseData?.option_set_count ?? "") ?? 0
    }
    
  }
  
  func fetchData(){
    
    survey_id = cheeseData?.id ?? ""
    guard let id = survey_id else { return }
    CheeseService.survayResult(surveyId: id) { [weak self] (response) in
      guard let `self` = self else {return}
      switch response.result {
      case .success(let value):
        self.resultData = value.data ?? []
        self.addEmptyResultData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
      self.collectionView.reloadData()
    }
    fetchReply()
  }
  
  
  private func addEmptyResultData(){
    if "\(self.resultData.count)" != (cheeseData?.type ?? "0") {
      guard let id = self.resultData.first?.survay_id else {return}
    }
  }
  
  
  func searchOtherRankAction(){
    
    switch openData.openType {
    case .normal:
      let VC = CheeseResultOtherViewController()
      VC.cheeseData = CheeseResult(cheeseData: self.cheeseData, resultData: self.resultData)
      self.navigationController?.pushViewController(VC, animated: true)

    case .search:
      break
    case .url(_):
      if !openData.isLogin{
        let alertController = UIAlertController(title: "알림", message: "앗! 소중한 치즈카운터\n회원님만 가능한 기능이에요~\n로그인 및 가입을\n원하시면 아래 확인 버튼을 눌러주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
        }))
        self.present(alertController, animated: true, completion: nil)
      }else{
        let VC = CheeseResultOtherViewController()
        VC.cheeseData = CheeseResult(cheeseData: self.cheeseData, resultData: self.resultData)
        self.navigationController?.pushViewController(VC, animated: true)
      }
    }
  }
  
  func hartButtonAction(_ sender: UIButton){
    if !sender.isSelected{
      CheeseService.insertEmpathy(id: self.cheeseData?.id ?? "") { (result) in
        if result.0 == "200"{
          sender.isSelected = true
        }else {
          AlertView(title: result.1)
            .addChildAction(title: "확인", style: .default, handeler: nil)
            .show()
        }
      }
    }
  }
  
  func refreshControlDidChangeValue(){
    fetchData()
    self.refreshControl.endRefreshing()
  }
  
  override func keyboardWillShow(_ sender: Notification) {
    
    if let userInfo = (sender as NSNotification).userInfo {
      if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
        
        switch openData.openType {
        case .url(_), .search:
          self.bottomConstraint?.update(inset: keyboardHeight)
        case .normal:
          self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
          self.bottomConstraint?.update(inset: keyboardHeight - replyView.bounds.height)
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  override func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        switch openData.openType {
        case .url(_), .search:
          self.bottomConstraint?.update(inset: 0)
        case .normal:
          self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
          self.bottomConstraint?.update(inset: 0)
          
          UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.view.layoutIfNeeded() })
        }
      }
    }
  }
}

extension CheeseResultViewController: UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    _ = self.replyTextView.resignFirstResponder()
    selectIndexPath = indexPath
    self.replyTextView.tag = 0
    self.replyTextView.textView.text = ""
    self.replyTextView.placeholderAttributedText = NSAttributedString(string: "댓글을 입력하세요..."
      ,attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
        ,NSForegroundColorAttributeName: UIColor.gray])
    self.replyTextView.endEditing(true)
  }
}

extension CheeseResultViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let height = self.replyData[indexPath.item]
      .contents?
      .boundingRect(with: CGSize(width: collectionView.frame.width - 91, height: UIScreen.main.bounds.height)
        , attributes:  [NSFontAttributeName:UIFont.CheeseFontRegular(size: 12)]).height
    return CGSize(width: collectionView.frame.width, height: (height ?? 0) + 60)
  }
}

extension CheeseResultViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView
    , viewForSupplementaryElementOfKind kind: String
    , at indexPath: IndexPath) -> UICollectionReusableView {
    
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: CheeseResultViewCell.self), for: indexPath) as! CheeseResultViewCell
    if let cheese = cheeseData{
      view.setViewData(cheeseData: cheese, topRankData: topRankSurveyData, totalCount: totalCount)
      view.hartButton.addTarget(self, action: #selector(hartButtonAction(_:)), for: .touchUpInside)
      view.didTap = {
        self.searchOtherRankAction()
      }
    }
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:RereplyViewCell.self), for: indexPath) as! RereplyViewCell
    cell.fetchData(data: self.replyData[indexPath.item])
    cell.tag = indexPath.item
    cell.writeReplyButton.tag = indexPath.item
    cell.sympathyButton.tag = indexPath.item
    cell.writeReplyButton.addTarget(self, action: #selector(writeReReply(_:)), for: .touchUpInside)
    cell.sympathyButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(replyDeleteAction(_:)))
    cell.addGestureRecognizer(longPressGesture)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.replyData.count
  }
}
