//
//  UIViewControllerExtension.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
  // MARK: - Message Error
  func showMessage(title: String, message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    self.view.endEditing(true)
  }

  func showHUD(_ text:String){
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.label.text = text
    UIApplication.showNetworkActivity()
  }
    
  @objc func hideHUD(){
    MBProgressHUD.hide(for: self.view, animated: true)
    UIApplication.hideNetworkActivity()
  }

}

extension UIView {
  func roundCorners(radius:Float, corners:CACornerMask) {
    
    self.clipsToBounds = true
    self.layer.cornerRadius = CGFloat(radius)
    self.layer.maskedCorners = corners
  }
}
