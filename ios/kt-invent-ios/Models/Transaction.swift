//
//  Transaction.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation

import UIKit
import SwiftDate
import SwiftyJSON

class Transaction {
  // MARK: Properties
  var id:String
  var name:String
  var category:String
  var date:Date?
  var amount:Float
  var billUrl:String?
  var transactions:[Transaction] = []
  
  init(id:String, name:String, category: String, date: Date, amount:Float) {
    self.id = id
    self.name = name
    self.category = category
    self.date = date
    self.amount = amount
    
  }
  var timeLabel: String {
    guard let date = self.date else {
      return "Bilinmiyor"
    }
    return DateInRegion(date).toFormat("HH:mm")
  }
  
  var dateLabel: String {
    guard let date = self.date else {
      return "Bilinmiyor"
    }
    return DateInRegion(date).toFormat("dd MMMM yyyy - HH:mm", locale: Locales.turkish)
  }
  
  var amountLabel: String {
    return "₺ \(amount)"
  }
  
  var categoryImage: UIImage {
    switch self.category {
    case "restoran":
      return UIImage(named: "dress")!
    case "market":
      return UIImage(named: "food")!
    case "Akaryakıt":
      return UIImage(named: "gas")!
    default:
      return UIImage(named: "dress")!
    }
  }
  
  // MARK: Constructor
  init(fromJSON json:JSON){
    self.id = json["_id"].stringValue
    self.name = json["name"].stringValue
    self.category = json["category"].stringValue
    self.amount = json["totalAmount"].floatValue
    self.date = json["createdAt"].stringValue.toDate()?.date
    self.billUrl = json["receiptUrl"].string
    self.appendTransactions(fromJSON: json["items"])
  }
  
  func appendTransactions(fromJSON json:JSON){
    for (_, transactionJson):(String, JSON) in json {
      self.transactions.append(Transaction(fromJSON: transactionJson))
    }
  }
}
