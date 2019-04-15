//
//  AccountManager.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import AuthenticationServices

class AccountManager {
  var authSession: ASWebAuthenticationSession?
  
  static var shared = AccountManager()
  
  func start(success: @escaping (_ url:String) -> ()) {
    print("Kuveyt Türk Login")
    //Initialize auth session
    print(Web.KT.AuthURL)
    self.authSession = ASWebAuthenticationSession(url: Web.KT.AuthURL, callbackURLScheme: Web.KT.CallbackUrl, completionHandler: {
      (callBack:URL?, error:Error? ) in
      guard error == nil, let successURL = callBack else {
        print(error!)
        return
      }
      var user = UserDataManager.currentUser!
      user.kt = true
      UserDataManager.currentUser = user
      print(successURL.absoluteString)
      success(successURL.absoluteString)
    })
    self.authSession?.start()
  }
  
  func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
  }
}

