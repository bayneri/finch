//
//  UserDataManager.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  static var currentUser: User? {
    get {
      let defaults = UserDefaults.standard
      if let data = defaults.data(forKey: "kt-invent-user"), let user = try? JSONDecoder().decode(User.self, from: data) {
        return user
      }
      return nil
    }
    
    set {
      let user = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(user, forKey: "kt-invent-user")
    }
  }
  
  class func deleteUser() {
    UserDefaults.standard.removeObject(forKey: "kt-invent-user")
  }
  
  static var isUserLogged: Bool {
    return currentUser != nil
  }
}
