//
//  KTTextField.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  
  let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  func initView() {
    self.setRoundBorders(CGFloat(18))
    self.backgroundColor = UIColor(hexString: "#458efd")
//    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//    self.layer.shadowColor = UIColor.black.cgColor
//    self.layer.shadowOpacity = 0.4
//    self.layer.shadowOffset = CGSize(width: 5, height: 5)
//    self.layer.shadowRadius = 2
//    self.layer.masksToBounds = false
  }
}
