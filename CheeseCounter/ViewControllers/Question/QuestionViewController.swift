//
//  QuestionViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import NVActivityIndicatorView

public enum QuestionImageType{
  case url(String)
  case image(UIImage)
}

public enum QuestionType: String{
  case Two = "2"
  case Four = "4"
}

public struct QuestionModel: Equatable{
  
  var title: String
  var type: QuestionType
  var ask1: String
  var ask2: String
  var ask3: String
  var ask4: String
  var image1: UIImage
  var image2: UIImage
  var image3: UIImage
  var image4: UIImage
  var hash_tag: String
  var img_status: String
  var is_option: String
  
  init() {
    title = String()
    type = .Two
    ask1 = String()
    ask2 = String()
    ask3 = String()
    ask4 = String()
    image1 = UIImage()
    image2 = UIImage()
    image3 = UIImage()
    image4 = UIImage()
    hash_tag = String()
    img_status = String()
    is_option = String()
  }
  public static func ==(lhs: QuestionModel, rhs: QuestionModel) -> Bool {
    return lhs.title == rhs.title
  }
}

class QuestionViewController: FormViewController{
  
  let disposeBag = DisposeBag()
  var isInit: Bool = false
  var initForm: Form?
  
  var model = QuestionModel()
  
  let indicator: NVActivityIndicatorView = {
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .lightGray)
    indicator.isHidden = true
    return indicator
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "질문"
    tableView.addSubview(indicator)
    
    indicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.height.width.equalTo(50)
    }
    
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    form +++ Section()
      <<< TitleRow(tag: "title").cellSetup({[weak self] (cell, row) in
        row.value = self?.model
      })
      <<< SelectionButtonRow(tag: "selectType")
      
      <<< ImageRow(tag: "imageRow").cellSetup({[weak self] (cell, row) in
        guard let `self` = self else {return}
        cell.touchEvent?.subscribe(onNext: {[weak self] (imgView) in
          guard let `self` = self else {return}
          self.showSelectImageView(imageView: imgView)
        }).disposed(by: self.disposeBag)
      })
      <<< AskRow("askRow")
      
      <<< ImageRow(tag: "imageRow1").cellSetup({[weak self] (cell, row) in
        guard let `self` = self else {return}
        cell.touchEvent?.subscribe(onNext: {[weak self] (imgView) in
          guard let `self` = self else {return}
          self.showSelectImageView(imageView: imgView)
        }).disposed(by: self.disposeBag)
      })
        .cellUpdate({ (cell, row) in
        row.hidden = Condition.function(["selectType"], { (form) -> Bool in
          if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
            return row.value == .Two
          }else{
            return false
          }
        })
      })
      
      <<< AskRow(tag: "askRow1").cellUpdate({ (cell, row) in
        row.hidden = Condition.function(["selectType"], { (form) -> Bool in
          if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
            return row.value == .Two
          }else{
            return false
          }
        })
      })
      
      +++ Section(){ section in
        section.header = {
          var header = HeaderFooterView<UILabel>(.callback({
            let label = UILabel()
            label.text = "    태그"
            return label
          }))
          header.height = {30}
          return header
        }()
      }
      <<< TagRow(tag: "tagRow")
      <<< SubmitRow().cellSetup({[weak self] (cell, row) in
        guard let `self` = self else {return}
        cell.submitButton.rx
          .tap
          .debounce(1, scheduler: MainScheduler.instance)
          .do(onNext: {[weak self] _ in self?.tableView.isUserInteractionEnabled = false})
          .bind(onNext: self.uploadDatas)
          .disposed(by: cell.disposeBag)
      })
    initForm = form
  }
  
  private func showSelectImageView(imageView: QuestionImageView){
    let pickerViewController = PickerViewController()
    pickerViewController
      .imageSelected
      .subscribe(onNext: { (type) in
        switch type{
        case .image(let image):
          imageView.image = image
        case .url(let url):
          imageView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
        }
      }).disposed(by: pickerViewController.disposeBag)
    self.navigationController?.pushViewController(pickerViewController, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard !isInit else {return}
    if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
      row.value = .Two
      row.updateCell()
    }
    isInit = true
  }
  
  private func uploadDatas(){
    
    indicator.startAnimating()
    indicator.isHidden = false
    defer {
      self.tableView.isUserInteractionEnabled = true
      self.indicator.isHidden = true
    }
    
    let titleRow: TitleRow? = form.rowBy(tag: "title")
    let sectionType: SelectionButtonRow? = form.rowBy(tag: "selectType")
    let imgrow: ImageRow? = form.rowBy(tag: "imageRow")
    let imgrow1: ImageRow? = form.rowBy(tag: "imageRow1")
    let askrow: AskRow? = form.rowBy(tag: "askRow")
    let askrow1: AskRow? = form.rowBy(tag: "askRow1")
    let tagRow: TagRow? = form.rowBy(tag: "tagRow")
    
    // Validation Check
    guard (titleRow?.cell.isValid ?? false) &&
      (imgrow?.cell.isValid ?? false) &&
      (askrow?.cell.isValid ?? false) &&
      (tagRow?.cell.isValid ?? false) else{
      alertAction(title: "필수 사항을 입력해 주세요.")
      return
    }
    let title = titleRow?.cell.titleField.text
    let section = sectionType?.value?.rawValue
    let image1 = imgrow?.cell.firstImgView.image
    let image2 = imgrow?.cell.secondImgView.image
    let image3 = imgrow?.cell.firstImgView.image
    let image4 = imgrow?.cell.secondImgView.image
    let ask1 = askrow?.cell.ask1Field.text
    let ask2 = askrow?.cell.ask2Field.text
    let ask3 = askrow1?.cell.ask1Field.text
    let ask4 = askrow1?.cell.ask1Field.text
    let tags = tagRow?.cell.tagText
    let image1Data = UIImageJPEGRepresentation(image1!, 1)
    let image2Data = UIImageJPEGRepresentation(image2!, 1)
    
    
    var multiparts:[MultipartFormData] = []
    
    multiparts.append(MultipartFormData(provider: .data(title!.data(using: .utf8)!), name: "title"))
    multiparts.append(MultipartFormData(provider: .data(section!.data(using: .utf8)!), name: "type"))
    multiparts.append(MultipartFormData(provider: .data(ask1!.data(using: .utf8)!), name: "ask1"))
    multiparts.append(MultipartFormData(provider: .data(ask2!.data(using: .utf8)!), name: "ask2"))
    multiparts.append(MultipartFormData(provider: .data(tags!.data(using: .utf8)!), name: "hash_tag"))
    multiparts.append(MultipartFormData(provider: .data("0".data(using: .utf8)!), name: "is_option"))
    multiparts.append(MultipartFormData(provider: .data(image1Data!), name: "img_file", fileName: "jpg", mimeType: "image/jpeg"))
    multiparts.append(MultipartFormData(provider: .data(image2Data!), name: "img_file", fileName: "jpg", mimeType: "image/jpeg"))
    if sectionType?.value == .Four{
      guard (imgrow1?.cell.isValid ?? false) && (askrow1?.cell.isValid ?? false) else {return}
      let image3Data = UIImageJPEGRepresentation(image3!, 1)
      let image4Data = UIImageJPEGRepresentation(image4!, 1)
      multiparts.append(MultipartFormData(provider: .data(image3Data!), name: "img_file",  fileName: "jpg", mimeType: "image/jpeg"))
      multiparts.append(MultipartFormData(provider: .data(image4Data!), name: "img_file", fileName: "jpg", mimeType: "image/jpeg"))
      multiparts.append(MultipartFormData(provider: .data(ask3!.data(using: .utf8)!), name: "ask3"))
      multiparts.append(MultipartFormData(provider: .data(ask4!.data(using: .utf8)!), name: "ask4"))
      multiparts.append(MultipartFormData(provider: .data("0,1,2,3".data(using: .utf8)!), name: "img_status"))
    }else{
      multiparts.append(MultipartFormData(provider: .data("0,1,none,none".data(using: .utf8)!), name: "img_status"))
    }
    
    CheeseService.provider
      .request(.insertSurvey(data: multiparts))
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: {[weak self] (response) in
        if response["result"]["code"].intValue == 200{
          self?.alertAction(title: "작성이 완료되었습니다.")
          self?.refreshData()
        }else{
          self?.alertAction(title: response["result"]["data"].stringValue)
        }
      }, onError: { (error) in
        log.error(error)
      }).disposed(by:disposeBag)
  }
  
  func refreshData(){
    let titleRow: TitleRow? = form.rowBy(tag: "title")
    let sectionType: SelectionButtonRow? = form.rowBy(tag: "selectType")
    let imgrow: ImageRow? = form.rowBy(tag: "imageRow")
    let imgrow1: ImageRow? = form.rowBy(tag: "imageRow1")
    let askrow: AskRow? = form.rowBy(tag: "askRow")
    let askrow1: AskRow? = form.rowBy(tag: "askRow1")
    let tagRow: TagRow? = form.rowBy(tag: "tagRow")
    
    titleRow?.cell.titleField.text = nil
    sectionType?.value = .Two
    imgrow?.cell.firstImgView.image =  #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal)
    imgrow?.cell.secondImgView.image =  #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal)
    imgrow1?.cell.firstImgView.image =  #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal)
    imgrow1?.cell.secondImgView.image =  #imageLiteral(resourceName: "question_img_nomal@1x").withRenderingMode(.alwaysOriginal)
    askrow?.cell.ask1Field.text = nil
    askrow?.cell.ask2Field.text = nil
    askrow1?.cell.ask1Field.text = nil
    askrow1?.cell.ask2Field.text = nil
    tagRow?.cell.tagsField.removeTags()
  }
  
  func alertAction(title: String){
    let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    self.present(vc, animated: true, completion: nil)
  }
}
