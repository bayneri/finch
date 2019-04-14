//
//  TransactionAPI.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransactionAPI {
  
  class func getTransactions(success: @escaping (_ transactions: [(String, [Transaction])]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.requestJson(.get, url:  "/transaction", success: { response in
      var transactions:[(String, [Transaction])] = []
      for (_, dateJson):(String, JSON) in response["transactions"] {
        let date = dateJson["date"].stringValue
        var transactionsByDate:[Transaction] = []
        for (_, transactionJson):(String, JSON) in dateJson["transactions"] {
          transactionsByDate.append(Transaction(fromJSON: transactionJson))
        }
        transactions.append((date, transactionsByDate))
      }
      success(transactions)
    }, failure: { error in
      failure(error)
    })
  }
  
  //Example method that uploads base64 encoded image.
  class func sendBill(transaction: Transaction, bill: UIImage, success: @escaping (_ response: JSON) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let picData = resizeImage(image: bill, height: 1080).jpegData(compressionQuality: 0.75)
    let parameters = [
      "transactionId": transaction.id,
      "image": picData!.asBase64Param()
    ]
    
    APIClient.requestJson(.post, url: "/receipt", params: parameters, success: { response in
      print(response)
      success(response)
    }, failure: { error in
      failure(error)
    })
  }
  
  class func resizeImage(image: UIImage, height: CGFloat) -> UIImage {
    let size = image.size
    let targetSize = CGSize(width: height * (size.width / size.height), height: height)
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}
