//
//  AlertView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 12..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class AlertView{
    let alertView:UIAlertController!
    
  init(title:String,message:String = "",preferredStyle:UIAlertControllerStyle = .alert) {
        alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    func addChildAction(title:String,style:UIAlertActionStyle,handeler:((UIAlertAction)-> Void)?) -> Self{
        self.alertView.addAction(UIAlertAction(title: title, style: style, handler: handeler))
        return self
    }
    
    func show(){
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}
