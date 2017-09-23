//
//  LinkFeedController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import KakaoLink
import KakaoS2
import FBSDKShareKit


class ShareController{
  
  
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
  
  static func shareAction(title: String, tag: String, imageURL: URL?, webURL: URL?,surveyId: String,likeCount: NSNumber, commnentCount: NSNumber){
    let template = KLKFeedTemplate { (feedTemplateBuilder) in
      feedTemplateBuilder.content = KLKContentObject(builderBlock: { (contentBuilder) in
        contentBuilder.title = title
        contentBuilder.desc = tag
        contentBuilder.imageURL = imageURL!
        contentBuilder.link = KLKLinkObject(builderBlock: { (linkBuilder) in
          linkBuilder.mobileWebURL = webURL
        })
      })
      
      feedTemplateBuilder.social = KLKSocialObject.init(builderBlock: { (socialBuilder) in
        socialBuilder.likeCount = likeCount
        socialBuilder.commnentCount = commnentCount
      })
      
      feedTemplateBuilder.addButton(KLKButtonObject.init(builderBlock: { (buttonBuilder) in
        buttonBuilder.title = "앱으로 보기"
        buttonBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
          linkBuilder.mobileWebURL = webURL
          linkBuilder.iosExecutionParams = "kWGPa9nW=\(surveyId)"
          linkBuilder.androidExecutionParams = "kWGPa9nW=\(surveyId)"
        })
      }))
    }
    
//    self.view.startLoading()
    KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
      
      // 성공
//      self.view.stopLoading()
      
    }, failure: { (error) in
      
      // 실패
//      self.view.stopLoading()
      log.error(error.localizedDescription)
      
    })
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
