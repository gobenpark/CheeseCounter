//
//  LinkFeedController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import XLActionController
import KakaoLink
import KakaoS2
import KakaoMessageTemplate
import FBSDKShareKit
import FirebaseDynamicLinks



class ShareController{
  static func kakaoShareAction(title: String, tag: String, imageURL: URL, webURL: URL?,surveyId: String, likeCount: NSNumber,commnentCount: NSNumber){
    let template = KMTFeedTemplate { (builder) in
      builder.content = KMTContentObject(builderBlock: { (contentBuilder) in
        contentBuilder.title = title
        contentBuilder.desc = tag
        contentBuilder.imageURL = imageURL
        contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
          linkBuilder.mobileWebURL = webURL
        })
      })
      
      builder.social = KMTSocialObject(builderBlock: { (socialBuilder) in
        socialBuilder.likeCount = likeCount
        socialBuilder.commnentCount = commnentCount
      })
      
      builder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
        buttonBuilder.title = "앱으로 보기"
        buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
          linkBuilder.mobileWebURL = webURL
          linkBuilder.iosExecutionParams = "kWGPa9nW=\(surveyId)"
          linkBuilder.androidExecutionParams = "kWGPa9nW=\(surveyId)"
        })
      }))
    }
    
    KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
    }) { (error) in
      log.error(error)
    }
  }
  
  static func dynamicLinks(surveyId: String,title: String, imageURL: URL,_ completion: @escaping (URL?)->Void){
    
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
  
  static func shareActionSheet(model: CheeseViewModel.Item, fromViewController: UIViewController) -> TwitterActionController{
    let actionSheet = TwitterActionController()
    actionSheet.headerData = "공유하기"
    
    let kakaoAction = Action(ActionData(title: "카카오톡 공유", image: #imageLiteral(resourceName: "share_kakao@1x")), style: .default) { (_) in
      guard let imgURL = URL(string: model.main_img_url?.getUrlWithEncoding() ?? String()) else {return}
      ShareController.dynamicLinks(surveyId: model.id, title: model.title, imageURL: imgURL, { (url) in
        guard let url = url else {return}
        ShareController.kakaoShareAction(title: model.title, tag: model.hash_tag, imageURL: imgURL, webURL: url, surveyId: model.id, likeCount: 0, commnentCount: 0)
      })
    }
    
    let faceBookAction = Action(ActionData(title: "페이스북 공유", image: #imageLiteral(resourceName: "share_facebook@1x")), style: .default) { (_) in
      guard let imgURL = URL(string: model.main_img_url?.getUrlWithEncoding() ?? String())  else {return}
      ShareController.dynamicLinks(surveyId: model.id, title: model.title, imageURL: imgURL, { (url) in
        guard let url = url else {return}
        ShareController.fbShareAction(contentURL: url, hashTag: model.hash_tag, fromViewController: fromViewController)
      })
    }
    
    let kakaoStoryAction = Action(ActionData(title: "카카오스토리 공유", image: #imageLiteral(resourceName: "share_kakaostory@1x")), style: .default) { (_) in
      KOSessionTask.storyIsStoryUserTask(completionHandler: { (isStoryUser, error) in
        if error == nil{
          ShareController.kakaoStoryLink(model: model)
        }else {
          log.error(error?.localizedDescription ?? "")
        }
      })
    }
    actionSheet.addAction(kakaoAction)
    actionSheet.addAction(faceBookAction)
    actionSheet.addAction(kakaoStoryAction)
    return actionSheet
  }
  
  static func fbShareAction(contentURL: URL ,hashTag: String ,fromViewController: UIViewController){
    // LIKE Action
    
    let content = FBSDKShareLinkContent()
    content.contentURL = contentURL
    content.hashtag = FBSDKHashtag(string: hashTag)
    
    let photo = FBSDKSharePhoto()
    photo.image = nil
    photo.isUserGenerated = true
    let content2 = FBSDKSharePhotoContent()
    content2.photos = [photo]
    
    let dialog = FBSDKShareDialog()
    dialog.fromViewController = fromViewController
    dialog.shareContent = content
    
    dialog.mode = .shareSheet
    dialog.show()
  }
  

  static func kakaoStoryLink(model:CheeseViewModel.Item){
    
   
      guard let imgURL = URL(string: model.main_img_url?.getUrlWithEncoding() ?? String()) else {return}

      ShareController.dynamicLinks(surveyId: model.id, title: model.title, imageURL: imgURL){(url) in
        guard let url = url else {return}
        KOSessionTask.storyGetLinkInfoTask(withUrl: url.absoluteString, completionHandler: { (link, error) in
          if error == nil {
            KOSessionTask.storyPostLinkTask(with: link,
                                            content: model.title,
                                            permission: KOStoryPostPermission.public,
                                            sharable: true,
                                            androidExecParam: nil,
                                            iosExecParam: nil,
                                            completionHandler: { (post, error) in
                                              if error == nil{
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
  
  static func dummyStoryLinkURLString(_ title:String,_ desc: String,_ imgURL: String) -> String! {
    let bundle = Bundle.main

    if let bundleId = bundle.bundleIdentifier, let appVersion: String = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
      let appName: String = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
      
      return "storylink://posting?post=\("네임")&appid=\(bundleId)&appver=\(appVersion)&apiver=1.0&appname=치즈카운터"
    }
    return nil
  }
  
  static func kakaoStory(title: String, desc: String, imgURL: String){

    if let urlString = dummyStoryLinkURLString(title,desc,imgURL) {
      let url = URL(string: urlString)
      UIApplication.shared.openURL(url!)
    }
  }
}
