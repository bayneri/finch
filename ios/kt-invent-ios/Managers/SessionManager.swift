//
//  SessionDataManager.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class SessionManager: NSObject {
  
  static var currentSession: Session? {
    get {
      if let data = UserDefaults.standard.data(forKey: "kt-invent-session"), let session = try? JSONDecoder().decode(Session.self, from: data) {
        return session
      }
      return nil
    }
    
    set {
      let session = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(session, forKey: "kt-invent-session")
    }
  }
  
  class func deleteSession() {
    UserDefaults.standard.removeObject(forKey: "kt-invent-session")
  }
  
  static var validSession: Bool {
    if let session = currentSession, let token = session.token {
      return !token.isEmpty
    }
    return false
  }
}
