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
    return "₺\(String(format: "%.2f", amount))"
  }
  
  var categoryImage: UIImage {
    let categories = [
      "baby": ["Bebek, Oyuncak", "Anne Ürünleri", "Bebek Ürünleri", "Oyuncaklar", "Oyuncak", "Bebek Bezi"],
      "clean": ["Deterjan, Temizlik", "Çamaşır Gereçleri", "Ev Temizlik Gereçleri", "Banyo Gereçleri", "Bulaşık Yıkama", "Ev Temizlik Ürünleri", "Çamaşır Yıkama"],
      "meat": ["Et, Balık, Kümes", "Kırmızı Et", "Kümes Hayvanları", "Balık, Deniz Ürünleri"],
      "pet": ["Ev, Pet", "Pet Ürünleri"],
      "home": ["Kişisel İlgi, Eğlence", "Bahçe, Çiçek, Kamp, Piknik", "Kitap, Dergi, Kırtasiye", "Elektrik, Elektronik", "Ev, Ofis, Bahçe Dekorasyon", "Tekstil, Giyim, Aksesuar", "Mutfak Eşya, Gereçleri"],
      "food": [ "Gıda, Şekerleme", "Yemek", "Şekersiz Tatlandırıcılı Ürünler", "Sıvı Yağlar", "Çikolata, Gofret", "Şeker", "Bisküvi, Çerez", "Hazır Yemek, Konserve, Salça", "Meze", "Çorba Ve Bulyonlar", "Tuz, Baharat, Harç", "Sağlıklı Yaşam Ürünleri", "Unlu Mamül, Tatlı", "Sakız, Şekerleme", "Dondurulmuş Gıda", "Bakliyat, Makarna" ],
      "cosmetics":  ["Kağıt, Kozmetik", "Hijyenik Pedler", "Makyaj Ve Süs Ürünleri", "Ağdalar, Tüy Dökücüler", "Tıraş Malzemeleri", "Sağlık Ürünleri", "Vücut, Cilt Bakım", "Ağız Bakım Ürünleri", "Kağıt Ürünleri", "Parfüm, Deodorant", "Duş, Banyo, Sabun", "Saç Bakım"],
      "fruit": ["Meyve, Sebze", "Meyve", "Sebze"],
      "breakfast": ["Süt, Kahvaltılık", "Yoğurt", "Süt", "Yumurta", "Dondurma", "Peynir", "Sütlü Tatlı, Krema", "Tereyağ, Margarin", "Kahvaltılıklar"],
      "drinks": ["Çay & Kahve", "Cafe & Restoran", "İçecek", "Gazlı İçecekler", "Çay, Kahve", "Günlük İçecek", "Sular", "Maden Suları", "Gazsız İçecekler" ],
      "fuel": ["Benzin", "Akaryakıt"],
      "smoke": ["Sigara"],
      "alcohol": ["Alkol"],
      "restaurant": ["Restoran"],
      "electronic": ["Bilgisayar", "Telefon", "Elektronik"],
      "market": ["market", "Market"]

    ]
  
    for (name, subs) in categories {
      if subs.contains(self.category) {
        return UIImage(named: name)!
      }
    }
    
    return UIImage(named: "default")!
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
