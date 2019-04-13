//
//  Session.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation

class Session: Codable {
  var token: String?
  
  private enum CodingKeys: String, CodingKey {
    case token = "token"
  }
  
  init(name: String? = nil, token: String? = nil) {
    self.token = token
  }
  
  init?(token:String) {
    self.token = token
  }
  
  //MARK: Codable
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(token, forKey: .token)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    token = try container.decode(String.self, forKey: .token)
  }
}
