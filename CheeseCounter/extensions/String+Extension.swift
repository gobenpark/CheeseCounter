//
//  String+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 10. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Foundation


extension String{
  var fileurl: URL {
    get {
      return URL(fileURLWithPath: self)
    }
  }
  
  func encodeUrl() -> String
  {
    return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
  }
  
  func boundingRect(with size: CGSize, attributes: [NSAttributedStringKey: Any]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }
  
  func getUrlWithEncoding() -> String{
    
    switch self{
    case _ where self.contains("/img/"):
      let index = self.index(self.startIndex, offsetBy: 5)
      let encodedUrl = String(self[index...]).encodeUrl()
      return UserService.imgString+"/img/"+encodedUrl
    case _ where self.contains("/baseImg/"):
      let index = self.index(self.startIndex, offsetBy: 9)
      let encodedUrl = String(self[index...]).encodeUrl()
      return UserService.imgString+"/baseImg/"+encodedUrl
    case _ where self.contains("/giftImg/"):
      let index = self.index(self.startIndex, offsetBy: 9)
      let encodedUrl = String(self[index...]).encodeUrl()
      return UserService.imgString+"/giftImg/"+encodedUrl
    default:
      return ""
    }
  }
  
  func getDynamicLink() -> String{
    
    return "https://x3exr.app.goo.gl/?link=https://www.cheesecounter.co.kr/cheese?survey=\(self)&apn=com.xiilab.servicedev.cheesecounter&isi=1235147317&ibi=com.xiilab.CheeseCounter&osl=https://x3exr.app.goo.gl/UDPG&fpbin=CJsFEPcCGgVrby1LUg==&cpt=cp&plt=1274&uit=1051&fpbin=CJsFEPcCGgVrby1LUg==&cpt=cp&plt=1274&uit=98318"
  }
}



