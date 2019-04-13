//
//  SignUpViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var signUp: KTButton!
  @IBOutlet weak var nameField: KTTextField!
  @IBOutlet weak var emailField: KTTextField!
  @IBOutlet weak var passwordField: KTTextField!
  @IBOutlet weak var passwordConfirmationField: KTTextField!

  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Actions
  @IBAction func signUp(_ sender: Any) {
    if nameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty || passwordConfirmationField.text!.isEmpty {
      self.showMessage(title: "Uyarı", message: "İsim, e-posta ve şifre boş bırakılamaz")
      return
    }
    
    if passwordField.text! != passwordConfirmationField.text! {
      self.showMessage(title: "Uyarı", message: "Şifreler aynı olmalıdır")
      return
    }

    self.showHUD("Hesap oluşturuluyor...")
    let name = nameField.text!
    let email = emailField.text!
    let password = passwordField.text!

    UserAPI.signup(name, email: email, password: password, success: { (_) in
      self.hideHUD()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.tabBarViewController()
    }, failure: { error in
      self.hideHUD()
      self.showMessage(title: "Hata", message: error.localizedDescription)
      print(error)
    })
  }
  
  @IBAction func goBack(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
}
