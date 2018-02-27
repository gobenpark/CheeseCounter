//
//  UIButton+Extension.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 25..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import Foundation


extension UIButton {
  
  /// Creates a duplicate of the terget UIButton
  /// The caller specified the UIControlEvent types to copy across to the duplicate
  ///
  /// - Parameter controlEvents: UIControlEvent types to copy
  /// - Returns: A UIButton duplicate of the original button
  func duplicate(forControlEvents controlEvents: [UIControlEvents]) -> UIButton? {
    
    // Attempt to duplicate button by archiving and unarchiving the original UIButton
    let archivedButton = NSKeyedArchiver.archivedData(withRootObject: self)
    guard let buttonDuplicate = NSKeyedUnarchiver.unarchiveObject(with: archivedButton) as? UIButton else { return nil }
    
    // Copy targets and associated actions
    self.allTargets.forEach { target in
      
      controlEvents.forEach { controlEvent in
        
        self.actions(forTarget: target, forControlEvent: controlEvent)?.forEach { action in
          buttonDuplicate.addTarget(target, action: Selector(action), for: controlEvent)
        }
      }
    }
    
    return buttonDuplicate
  }
}
