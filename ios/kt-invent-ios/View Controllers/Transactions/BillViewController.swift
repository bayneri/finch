//
//  HomeViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class BillViewController: UIViewController {

  var url:String = ""
  
  // MARK: - Outlets
  @IBOutlet weak var imageView: UIImageView!

  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadImage()
  }
  func loadImage() {
    imageView.load(url: URL(string: self.url)!)
  }
  
  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
