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

public enum QuestionImageType{
  case url(String)
  case image(UIImage)
}

public enum QuestionType: String{
  case Two = "2"
  case Four = "4"
}

public struct QuestionModel{
  var title: String
  var type: QuestionType
  var ask1: String
  var ask2: String
  var ask3: String
  var ask4: String
  var hash_tag: String
  var img_status: String
  var img_file: [UIImage]
  var is_option: String
}

class QuestionViewController: FormViewController{
  
  let disposeBag = DisposeBag()
  var isInit: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "질문"
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    form +++ Section()
      <<< TitleRow(tag: "title")
      <<< SelectionButtonRow(tag: "selectType").cellSetup({ (cell, row) in
        row.value = .Four
      })
      
      <<< ImageRow(tag: "imageRow").cellSetup({[weak self] (cell, row) in
        guard let `self` = self else {return}
        cell.touchEvent?.subscribe(onNext: {[weak self] (imgView) in
          guard let `self` = self else {return}
          let pickerViewController = PickerViewController()
          pickerViewController
            .imageSelected
            .subscribe(onNext: { (type) in
              switch type{
              case .image(let image):
                imgView.image = image
              case .url(let url):
                imgView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
              }
          }).disposed(by: pickerViewController.disposeBag)
          self.navigationController?.pushViewController(pickerViewController, animated: true)
        }).disposed(by: self.disposeBag)
      })
      <<< AskRow("askRow")
      <<< ImageRow(tag: "imageRow1").cellSetup({[weak self] (cell, row) in
        guard let `self` = self else {return}
        cell.touchEvent?.subscribe(onNext: {[weak self] (imgView) in
          guard let `self` = self else {return}
          let pickerViewController = PickerViewController()
          pickerViewController
            .imageSelected
            .subscribe(onNext: { (type) in
              switch type{
              case .image(let image):
                imgView.image = image
              case .url(let url):
                imgView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
              }
            }).disposed(by: pickerViewController.disposeBag)
          self.navigationController?.pushViewController(pickerViewController, animated: true)
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
        cell.submitButton.rx.tap
          .bind(onNext: self.uploadDatas)
          .disposed(by: cell.disposeBag)
      })
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
      
      return
    }
    var multiparts:[MultipartFormData] = []
    
    switch sectionType?.value{
    case .Two?:
      let title = titleRow?.cell.titleField.text
      let section = sectionType?.value?.rawValue
      let image1 = imgrow?.cell.firstImgView.image
      let image2 = imgrow?.cell.secondImgView.image
      let ask1 = askrow?.cell.ask1Field.text
      let ask2 = askrow?.cell.ask2Field.text
      let tags = tagRow?.cell.tagText
      let image1Data = UIImageJPEGRepresentation(image1!, 1)
      let image2Data = UIImageJPEGRepresentation(image2!, 1)
      
      multiparts.append(MultipartFormData(provider: .data(title!.data(using: .utf8)!), name: "title"))
      multiparts.append(MultipartFormData(provider: .data(section!.data(using: .utf8)!), name: "type"))
      multiparts.append(MultipartFormData(provider: .data(ask1!.data(using: .utf8)!), name: "ask1"))
      multiparts.append(MultipartFormData(provider: .data(ask2!.data(using: .utf8)!), name: "ask2"))
      multiparts.append(MultipartFormData(provider: .data(tags!.data(using: .utf8)!), name: "hash_tag"))
      multiparts.append(MultipartFormData(provider: .data("0,1,none,none".data(using: .utf8)!), name: "img_status"))
      multiparts.append(MultipartFormData(provider: .data("0".data(using: .utf8)!), name: "is_option"))
      multiparts.append(MultipartFormData(provider: .data(image1Data!), name: "img_file", fileName: "jpg", mimeType: "image/jpeg"))
      multiparts.append(MultipartFormData(provider: .data(image2Data!), name: "img_file", fileName: "jpg", mimeType: "image/jpeg"))
      
    case .Four?:
      guard (imgrow1?.cell.isValid ?? false) && (askrow1?.cell.isValid ?? false) else {return}
      
    case .none:
      break
    }
    
    CheeseService.provider
      .request(.insertSurvey(data: multiparts))
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: {[weak self] (response) in
        if response["result"]["code"].intValue == 200{
          self?.alertAction(title: "작성이 완료되었습니다.")
          self?.tableView.reloadData()
        }else{
          self?.alertAction(title: response["result"]["data"].stringValue)
        }
      }, onError: { (error) in
        log.error(error)
      }).disposed(by:disposeBag)
  }
  
  func alertAction(title: String){
    let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    vc.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    self.present(vc, animated: true, completion: nil)
  }
  
}
