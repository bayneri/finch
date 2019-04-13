//
//  UserServiceManager.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class UserAPI {
  
  fileprivate static let usersUrl = "/user/"
  fileprivate static let currentUserUrl = "/user/"
  
  class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "login"
    let parameters = [
      "email": email,
      "password": password
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      print(response)
      UserAPI.saveUserSession(fromResponse: response)
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
//  //Example method that uploads an image using multipart-form.
//  class func signup(_ email: String, password: String, avatar: UIImage, success: @escaping (_ response: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
//    let parameters = [
//      "user": [
//        "email": email,
//        "password": password,
//        "password_confirmation": password
//      ]
//    ]
//
//    let picData = avatar.jpegData(compressionQuality: 0.75)!
//    let image = MultipartMedia(key: "user[avatar]", data: picData)
//    //Mixed base64 encoded and multipart images are supported in [MultipartMedia] param:
//    //Example: let image2 = Base64Media(key: "user[image]", data: picData) Then: media [image, image2]
//    APIClient.multipartRequest(url: usersUrl, params: parameters, paramsRootKey: "", media: [image], success: { response, headers in
//      UserAPI.saveUserSession(fromResponse: response, headers: headers)
//      success(response)
//    }, failure: { (error) in
//      failure(error)
//    })
//  }
  
  //Example method that uploads base64 encoded image.
  class func signup(_ name: String, email: String, password: String, success: @escaping (_ response: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = [
      "name": name,
      "email": email,
      "password": password
    ]
    
    APIClient.request(.post, url: usersUrl, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response)
      success(response)
    }, failure: { error in
      failure(error)
    })
  }
  
  class func getMyProfile(_ success: @escaping (_ user: User) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "profile"
    APIClient.request(.get, url: url, success: { response, _ in
      do {
        let user = try JSONDecoder().decode(User.self, from: response["user"] as? [String: Any] ?? [:])
        success(user)
      } catch {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse a valid user".localized))
      }
    }, failure: { error in
      failure(error)
    })
  }
  
  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "facebook"
    let parameters = [
      "access_token": token
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response)
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
  class func saveUserSession(fromResponse response: [String: Any]) {
    print(response)
    UserDataManager.currentUser = try? JSONDecoder().decode(User.self, from: response as? [String: Any] ?? [:])
    SessionManager.currentSession = try? JSONDecoder().decode(Session.self, from: response as? [String: Any] ?? [:])
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_out"
    APIClient.request(.delete, url: url, success: {_, _ in
      UserDataManager.deleteUser()
      SessionManager.deleteSession()
      success()
    }, failure: { error in
      failure(error)
    })
  }
}
