//
//  Media.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import Foundation

struct Media {
  let mediaData: Data
  let mediaKey: String
  let mediaType: String
  
  init(data: Data, key: String, type: String) {
    mediaData = data
    mediaKey = key
    mediaType = type
  }
}
