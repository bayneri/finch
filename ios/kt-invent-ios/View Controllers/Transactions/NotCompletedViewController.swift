//
//  HomeViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import BWWalkthrough
import DZNEmptyDataSet
import SwiftDate

class NotCompletedViewController: UIViewController {
  var transactions:[Transaction] = []
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  func setupTableView() {
    tableView.tableFooterView = UIView()
    let backItem = UIBarButtonItem()
    backItem.title = "Geri"
    navigationItem.backBarButtonItem = backItem
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
    if let selectedRowNotNill = selectedRow {
      tableView.deselectRow(at: selectedRowNotNill, animated: true)
    }
    self.transactions = transactions.filter { $0.transactions.isEmpty && $0.billUrl == nil }
    self.tableView.reloadData()
    
  }
}

extension NotCompletedViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
    cell.setTransaction(transaction: transactions[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = self.storyboard!.transactionDetail()
    vc.transaction = self.transactions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
}
