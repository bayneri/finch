//
//  KTTextField.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class KTTextField: UITextField {
  
  
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
    self.configure(color: Theme.TextField.Color,
                   font: Theme.TextField.Font,
                   cornerRadius: 55/2,
                   borderColor: Theme.TextField.Border,
                   backgroundColor: Theme.TextField.Background,
                   borderWidth: 1.0)
    self.clipsToBounds = true
  }
  
  
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  func configure(color: UIColor = .blue,
                 font: UIFont = UIFont.boldSystemFont(ofSize: 12),
                 cornerRadius: CGFloat,
                 borderColor: UIColor? = nil,
                 backgroundColor: UIColor,
                 borderWidth: CGFloat? = nil) {
    if let borderWidth = borderWidth {
      self.layer.borderWidth = borderWidth
    }
    if let borderColor = borderColor {
      self.layer.borderColor = borderColor.cgColor
    }
    self.layer.cornerRadius = cornerRadius
    self.font = font
    self.textColor = color
    self.backgroundColor = backgroundColor
  }
  
}
