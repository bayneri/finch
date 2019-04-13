//
//  ViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var emailField: KTTextField!
  @IBOutlet weak var passwordField: KTTextField!
    
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func signIn(_ sender: Any) {
    if emailField.text!.isEmpty || passwordField.text!.isEmpty {
      self.showMessage(title: "Uyarı", message: "E-posta ve şifre boş bırakılamaz")
      return
    }

    self.showHUD("Giriş yapılıyor...")
    let email = emailField.text!
    let password = passwordField.text!

    UserAPI.login(email, password: password, success: {
      self.hideHUD()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.tabBarViewController()
    }, failure: { error in
      self.hideHUD()
      self.showMessage(title: "Hata", message: error.localizedDescription)
      print(error)
    })
  }
}
