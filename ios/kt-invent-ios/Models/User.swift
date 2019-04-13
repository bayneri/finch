//
//  User.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation

class User: Codable {
  var name: String
  var email: String
  var kt: Bool

  private enum CodingKeys: String, CodingKey {
    case name
    case email
    case kt
  }
  
  init(name: String = "", email: String, kt: Bool = false) {
    self.name = name
    self.email = email
    self.kt = kt
  }
  
  //MARK: Codable
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(email, forKey: .email)
    try container.encode(kt, forKey: .kt)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    email = try container.decode(String.self, forKey: .email)
    kt = try container.decode(Bool.self, forKey: .kt)
  }
}
