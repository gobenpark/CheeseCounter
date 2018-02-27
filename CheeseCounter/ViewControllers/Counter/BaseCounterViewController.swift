//
//  BaseCounterViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 21..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class BaseCounterViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    }
}

