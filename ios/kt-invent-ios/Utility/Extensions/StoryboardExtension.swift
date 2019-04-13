//
//  UIStoryboardExtension.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

extension UIStoryboard {
  class func instantiateViewController <T: UIViewController>(_ type: T.Type, storyboardIdentifier: String = "Main") -> T? {
    let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
    return storyboard.instantiateViewController(type)
  }
  
  func instantiateViewController <T: UIViewController>(_ type: T.Type) -> T? {
    return instantiateViewController(withIdentifier: String(describing: type)) as? T
  }
  
  func tabBarViewController() -> UIViewController {
    return self.instantiateViewController(withIdentifier: "TabBarViewController")
  }
  
  func transactionDetail() -> TransactionDetailViewController {
    return self.instantiateViewController(withIdentifier: "TransactionDetailViewController") as! TransactionDetailViewController
  }

  func billView() -> BillViewController {
    return self.instantiateViewController(withIdentifier: "BillViewController") as! BillViewController
  }

  func notCompletedView() -> NotCompletedViewController {
    return self.instantiateViewController(withIdentifier: "NotCompletedViewController") as! NotCompletedViewController
  }
}
