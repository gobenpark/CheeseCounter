//  Created by xiilab on 2017. 4. 5..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import SnapKit
import NextGrowingTextView
import DZNEmptyDataSet

struct UpLoadReplyData{
  
  var survey_id: Int
  var parent_id: Int
  var contents: String
  
  init() {
    self.survey_id = 0
    self.parent_id = 0
    self.contents = ""
  }
}

class CheeseBaseViewController: UIViewController {
  
  var bottomConstraint: Constraint?
  var selectIndexPath:IndexPath?
  var replyData:[ReplyList.Data] = []
  var survey_id: String?
  
  lazy var replyTextView: NextGrowingTextView = {
    let textView = NextGrowingTextView()
    textView.backgroundColor = .white
    textView.placeholderAttributedText = NSAttributedString(string: "댓글을 입력하세요..."
      ,attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
        ,NSForegroundColorAttributeName: UIColor.gray])
    textView.sizeToFit()
    return textView
  }()
  
  let replyView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.borderWidth = 0.5
    view.layer.borderColor = UIColor.lightGray.cgColor
    return view
  }()
  
  lazy var registerButton: UIButton = {
    let button = UIButton()
    button.setTitle("입력", for: .normal)
    button.setTitleColor(.lightGray, for: .normal)
    button.tag = 0
    button.addTarget(self, action: #selector(replayRegisterAction), for: .touchUpInside)
    return button
  }()
  
  var upLoadReplyData = UpLoadReplyData()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 1
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    if #available(iOS 10, *){
      collectionView.isPrefetchingEnabled = false
    }
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.definesPresentationContext = true
    self.view.addSubview(collectionView)
    self.view.addSubview(replyView)
    self.navigationItem.title = "결과보기"
    
    replyView.addSubview(replyTextView)
    replyView.addSubview(registerButton)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    replyView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      bottomConstraint = make.bottom.equalToSuperview().constraint
      make.top.equalTo(replyTextView).offset(-5)
    }
    
    replyTextView.snp.makeConstraints { (make) in
      make.left.equalTo(replyView.snp.leftMargin)
      make.bottom.equalToSuperview().inset(10)
      make.right.equalToSuperview().inset(80)
    }
    
    registerButton.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.left.equalTo(replyTextView.snp.right)
      make.bottom.equalToSuperview().inset(5)
    }
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
  }
  
  func setUp(){}
  
  func fetchReply(){
    
    CheeseService.getReplyList(surveyId: survey_id ?? "") {[weak self] (response) in
      if let `self` = self {
        var replyArray: [ReplyList.Data] = []
        self.replyData.removeAll()
        
        switch response.result{
        case .success(let value):
          guard let data = value.data else {return}
          
          let parentData = data.filter({ (data) -> Bool in
            data.parent_id == "0"
          })
          
          let childData = data.filter({ (data) -> Bool in
            data.parent_id != "0"
          })
          
          parentData.forEach({ (parent) in
            replyArray.append(parent)
            
            childData.forEach({ (child) in
              if child.parent_id == parent.id{
                replyArray.append(child)
              }
            })
          })
          self.replyData = replyArray
          
          self.collectionView.reloadData()
        case .failure(let error):
          log.error(error.localizedDescription)
        }
      }
    }
  }

  
  func replayRegisterAction(_ sender: UIButton){
    
    //replyTextView.tag는 부모아이디가 담김
    var parent_id: String = ""
    if replyTextView.tag != 0 {
      parent_id = "\(replyTextView.tag)"
    }
    _ = self.replyTextView.resignFirstResponder()
    guard let id = survey_id else { return }
    
    if replyTextView.textView.text.characters.count == 0 {
      let alertVC = UIAlertController(title: "알림", message: "댓글을 입력해주세요", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      
      self.present(alertVC, animated: true, completion: nil)

      return
    }
    
    let parameter:[String:String] = ["survey_id":id,"parent_id":parent_id,"contents":replyTextView.textView.text]
    
    CheeseService.insertReply(parameter: parameter) {[weak self] (result) in
      guard let `self` = self else {
        log.error("error!")
        return
      }
      if result.0 == "200"{
        self.alertSuccess(success: true, {
          self.replyTextView.textView.text = ""
          self.replyTextView.tag = 0
          DispatchQueue.main.async { [weak self] (_) in
            self?.fetchReply()
            if self?.collectionView.numberOfItems(inSection: 0) != 0{
              self?.collectionView.scrollToItem(at: IndexPath(item: sender.tag, section: 0), at: .top, animated: true)
            }
            sender.tag = 0
          }
          self.replyTextView.placeholderAttributedText = NSAttributedString(string: "댓글을 입력하세요..."
            ,attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
              ,NSForegroundColorAttributeName: UIColor.gray])
        })
      } else {
        AlertView(title: result.1)
          .addChildAction(title: "확인", style: .default, handeler: nil)
          .show()
      }
    }
  }
  
  dynamic func replyDeleteAction(_ sender: UIGestureRecognizer){
    
    guard let cell = self.collectionView.cellForItem(at:  IndexPath(item: sender.view?.tag ?? 0, section: 1)) as? RereplyViewCell else {return}
    //1 - 부모인지 검사
    
    guard cell.parentID != "0" else {return}
    
    //2 - 나의 댓글인지 검사
    let kakaoId = "KAKAO_" + "\(UserService.kakao_ID ?? 0)"
    guard cell.userID == kakaoId else {return}
    
    //3 - 수행
    AlertView(title: "삭제", message: "댓글을 삭제하시겠습니까?", preferredStyle: .actionSheet)
      .addChildAction(title: "예", style: .default) { [weak self] (_) in
        CheeseService.deleteReply(id: "\(cell.tag)",{ (result) in
          if result.0 == "200"{
            self?.fetchReply()
          }
        })
      }.show()
  }
  
  dynamic func writeReReply(_ sender: UIButton){
    
    _ = self.replyTextView.becomeFirstResponder()
    self.replyTextView.placeholderAttributedText = NSAttributedString(string: "대댓글을 입력하세요..."
      ,attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
        ,NSForegroundColorAttributeName: UIColor.gray])
    
    if let id = Int(replyData[sender.tag].id){
      self.replyTextView.tag = id
      self.registerButton.tag = sender.tag
    }
  }
  
  dynamic func likeButtonAction(_ sender: UIButton){
    
    let replyId = self.replyData[sender.tag].id ?? ""
    let surveyId = self.replyData[sender.tag].survey_id ?? ""
    guard !sender.isSelected else {return}
    CheeseService.insertLike(parameter: ["reply_id":replyId,"survey_id":surveyId], { [weak self](code) in
      if code == "200"{
        sender.isSelected = true
        self?.fetchReply()
      }
    })
    fetchReply()
  }
  
  
  fileprivate func alertSuccess(success:Bool,_ callBack: @escaping () -> Void){
    if success{
      let alertController = UIAlertController(title: "", message: "등록 되었습니다.", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
        callBack()
      }))
      self.present(alertController, animated: true, completion: nil)
    }else{
      let alertController = UIAlertController(title: "", message: "등록 실패", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
        callBack()
      }))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.bottomConstraint?.update(inset: 0)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.layoutIfNeeded() })
      }
    }
  }
  
  func keyboardWillShow(_ sender: Notification) {
    
    if let userInfo = (sender as NSNotification).userInfo {
      if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.bottomConstraint?.update(inset: keyboardHeight - replyView.bounds.height)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  func keyBoardDown(){
    replyTextView.textView.endEditing(true)
  }
}

extension CheeseBaseViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}


extension CheeseBaseViewController: DZNEmptyDataSetSource{
  
}


