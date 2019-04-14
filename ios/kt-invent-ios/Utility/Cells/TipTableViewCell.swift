//
//  TransactionTableViewCell.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import SwiftDate

class TipTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var categoryView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // progressView.transform = progressView.transform.scaledBy(x: 1, y: 8)
    progressView.layer.cornerRadius = 6
    progressView.clipsToBounds = true
    progressView.layer.sublayers![1].cornerRadius = 6
    progressView.subviews[1].clipsToBounds = true
  }
  
  
  func setTip(tip:(String, String, Int, Float)) {
    nameLabel.text = tip.0
    categoryView.image = UIImage(named: tip.1)!
    detailLabel.text = "₺\(tip.2) kaldı"
    progressView.progress = tip.3
    self.layoutIfNeeded()
  }

}
