//
//  ProfileViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   // MARK: - Actions
  
    @IBAction func logout(_ sender: Any) {
      self.showHUD("Çıkış Yapılıyor")
      UserDataManager.deleteUser()
      SessionManager.deleteSession()
      self.hideHUD()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
  }
}
