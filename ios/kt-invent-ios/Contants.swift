//
//  Constants.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

struct App {
  static let domain = Bundle.main.bundleIdentifier!
  static func error(domain: ErrorDomain = .generic, code: Int? = nil, localizedDescription: String = "") -> NSError {
    return NSError(domain: App.domain + "." + domain.rawValue,
                   code: code ?? 0,
                   userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }
}

struct Web {
  static let Base = "https://apifinch.herokuapp.com"
  struct KT {
    static let CallbackUrl = "KTInventOAuth://"
    static let RedirectUrl = "https://apifinch.herokuapp.com/auth/kuveyt"
    static let ClientId = "[KUVEYT_TURK_API_CLIENT_ID]"
//    UserDataManager.currentUser!.email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.replacingOccurrences(of: ".", with:"%2E")
    static let AuthURL = URL(string: "https://idprep.kuveytturk.com.tr/api/connect/authorize?client_id=\(ClientId)&response_type=code&redirect_uri=\(RedirectUrl)&state=\(SessionManager.currentSession!.token!)&scope=cards%20accounts%20offline_access")!
  }
}

struct Theme {
  static let KTColor = UIColor(hexString: "#036646")
  static let KTColorFade = UIColor(hexString: "#036646").withAlphaComponent(0.7)

  struct TextField {
    static let Font = UIFont.systemFont(ofSize: 18)
    static let Color = UIColor(hexString: "#746B68")
    static let Border = UIColor(hexString: "#746B68")
    static let Background = UIColor.white
  }

  struct Button {
    static let Font = UIFont.systemFont(ofSize: 17, weight: .medium)
    static let Color = UIColor.white
    static let Background = UIColor(red: 51/256, green: 51/256, blue: 51/256, alpha: 0.7)
    static let Radius = CGFloat(27)

  }

}


enum ErrorDomain: String {
  case generic = "GenericError"
  case parsing = "ParsingError"
}
