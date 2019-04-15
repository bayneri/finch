//
//  AccountViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import BWWalkthrough

class AccountViewController: UIViewController, BWWalkthroughPage {
    
  var delegate:WalkthroughDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
    @IBAction func accountLogin() {
      AccountManager.shared.start(){ url in
        if let delegate = self.delegate {
          delegate.closeWalkthrough()
        }
      }
    }
  // MARK: BWWalkThroughPage protocol
  
  func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
  }
}
