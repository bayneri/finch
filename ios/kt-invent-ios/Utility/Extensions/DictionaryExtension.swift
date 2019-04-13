//
//  DictionaryExtension.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation

//+ Operator definition for Dictionary types

func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
  var merge = left
  for (k, v) in right {
    merge[k] = v
  }
  return merge
}

func += <K, V> (left: inout [K: V], right: [K: V]) {
  left += right
}

extension Dictionary where Key: ExpressibleByStringLiteral {
  
  mutating func lowercaseKeys() {
    for key in self.keys {
      if let loweredKey = String(describing: key).lowercased() as? Key {
        self[loweredKey] = self.removeValue(forKey: key)
      }
    }
  }
}
