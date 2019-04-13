//
//  TransactionTableViewCell.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import SwiftDate

class TransactionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var categoryImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  func setTransaction(transaction:Transaction) {
    nameLabel.text = transaction.name
    dateLabel.text = transaction.timeLabel
    amountLabel.text = transaction.amountLabel
    categoryImageView.image = transaction.categoryImage
    
    self.layoutIfNeeded()
  }
  
  func setSubTransaction(transaction:Transaction) {
    nameLabel.text = transaction.name
    dateLabel.text = transaction.category
    amountLabel.text = transaction.amountLabel
    categoryImageView.image = transaction.categoryImage
    
    self.layoutIfNeeded()
  }

}
