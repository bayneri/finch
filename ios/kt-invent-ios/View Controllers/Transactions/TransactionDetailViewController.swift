//
//  TransactionDetailViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UITableViewController {
  
  var transaction:Transaction?
  var sectionHeaders = ["Ayrıntılar", "Alt Kırınımlar"]
  var imagePicker: UIImagePickerController!

  // MARK: - Outlets
  @IBOutlet weak var billButton:KTButton!

  var staticRows:[(key: String, value: String)] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = transaction?.name
    setupButton()
    
    staticRows = [
      (key: "İşlem", value: transaction!.name),
      (key: "Tutar", value: transaction!.amountLabel),
      (key: "Tarih", value: transaction!.dateLabel),
      (key: "Kategori", value: transaction!.category)
    ]
  }
  
  func setupButton () {
    if let _ = transaction?.billUrl {
      billButton.setTitle("FİŞİ GÖSTER", for: .normal)
      billButton.backgroundColor = UIColor(hexString: "#B1455B")
    } else {
      billButton.setTitle("FİŞ GÖNDER", for: .normal)
    }
  }
}

extension TransactionDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  // MARK: - Actions
  @IBAction func sendBill(_ sender: Any) {
    if let url = self.transaction?.billUrl {
      let vc = self.storyboard!.billView()
      vc.url = url
      self.present(vc, animated: true, completion: nil)
    } else {
      imagePicker =  UIImagePickerController()
      imagePicker.delegate = self
//      imagePicker.sourceType = .savedPhotosAlbum
      imagePicker.sourceType = .camera

      present(imagePicker, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imagePicker.dismiss(animated: true, completion: nil)
    if let image = info[.originalImage] as? UIImage {
      self.showHUD("Fiş Yükleniyor")
      TransactionAPI.sendBill(transaction: transaction!, bill: image, success: { response in
        print(response)
        self.transaction?.transactions = []
        self.transaction?.billUrl = response["receiptUrl"].string
        self.transaction?.appendTransactions(fromJSON: response["items"])
        self.setupButton()
        self.tableView.reloadData()
        self.hideHUD()
      }, failure: { error in
        self.hideHUD()
        self.showMessage(title: "Hata", message: error.localizedDescription)
        print(error)
      })
    }
    print(info)
  }

}

extension TransactionDetailViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return staticRows.count
    case 1:
      return transaction!.transactions.count
    default:
      return 0
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    if transaction!.transactions.isEmpty {
      return 1
    }
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "staticDetailCell", for: indexPath)
      cell.textLabel?.text = staticRows[indexPath.row].key
      cell.detailTextLabel?.text = staticRows[indexPath.row].value
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDetailCell", for: indexPath) as! TransactionTableViewCell
      cell.setSubTransaction(transaction: transaction!.transactions[indexPath.row])
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    case 1:
      return 62
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
}
