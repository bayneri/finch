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

protocol WalkthroughDelegate {
  func closeWalkthrough()
}
class HomeViewController: UIViewController {
  var walkthroughPresented = true
  var transactions:[(date:String, data:[Transaction])] = []
  var notCompletedTransactions:[Transaction] = []

  private let refreshControl = UIRefreshControl()

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusIcon: UIImageView!
  @IBOutlet weak var statusView: UIView!
  @IBOutlet weak var statusHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupStatusView()
    if let user = UserDataManager.currentUser, !user.kt {
      walkthroughPresented = false
    }
    if walkthroughPresented {
      self.fetchTransactions()
    }
  }
  
  func setupTableView() {
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    tableView.tableFooterView = UIView()
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(fetchTransactions), for: .valueChanged)
    refreshControl.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
    refreshControl.attributedTitle = NSAttributedString(string: "Harcamalarınız yükleniyor...")
    let backItem = UIBarButtonItem()
    backItem.title = "Geri"
    navigationItem.backBarButtonItem = backItem
  }

  func setupStatusView() {
    self.notCompletedTransactions = self.getNotCompletedTransactions()
    self.statusHeightConstraint.constant = 60
    self.loadViewIfNeeded()
    if notCompletedTransactions.isEmpty {
      self.statusLabel.text = "Bütün harcamalarınız düzenli gözüküyor"
      self.statusView.backgroundColor = UIColor(hexString: "#46CC7A")
      self.statusIcon.isHidden = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
        UIView.animate(withDuration: 2, animations: {
          self.statusHeightConstraint.constant = 0
          self.loadViewIfNeeded()
        })
      }

    } else {
      self.statusLabel.text = "İncelenmesi gereken \(notCompletedTransactions.count) harcamanız bulunuyor"
      if notCompletedTransactions.count > 10 {
        self.statusLabel.text = "İncelenmesi gereken 10'dan harcamanız bulunuyor"
      }
      self.statusView.backgroundColor = UIColor(hexString: "#B1455B")
      self.statusIcon.isHidden = false
    }
  }
  
  @IBAction func showUncompletedTransactions(_ sender: Any) {
    if !notCompletedTransactions.isEmpty {
      let vc = self.storyboard!.notCompletedView()
      vc.transactions = self.notCompletedTransactions
      navigationController?.pushViewController(vc, animated: true)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !walkthroughPresented {
      showOnboarding()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
    if let selectedRowNotNill = selectedRow {
      tableView.deselectRow(at: selectedRowNotNill, animated: true)
    }
  }
  
  @objc func fetchTransactions() {
    if !refreshControl.isRefreshing {
      self.showHUD("Harcamalarınız yükleniyor...")
    }
    
    TransactionAPI.getTransactions(success: { transactions in
      self.refreshControl.endRefreshing()
      self.hideHUD()
      self.transactions = transactions
//      self.notCompletedTransactions = notCompleted
//      self.notCompletedTransactions = [
//        Transaction(id: "11", name: "Denem", category: "market", date: Date(), amount: 231.4),
//        Transaction(id: "11", name: "Denem", category: "market", date: Date(), amount: 231.4)
//      ]

      self.setupStatusView()
      self.tableView.reloadData()
    }, failure: { error in
      self.refreshControl.endRefreshing()
      self.hideHUD()
      self.showMessage(title: "Hata", message: error.localizedDescription)
      print(error)
    })
  }
  
  func getNotCompletedTransactions() -> [Transaction] {
    var nTransactions: [Transaction] = []
    for transactionsByDate in transactions {
      nTransactions += transactionsByDate.data.filter { $0.transactions.isEmpty }
    }
    return nTransactions
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions[section].data.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
    cell.setTransaction(transaction: transactions[indexPath.section].data[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return transactions[section].date.toDate()!.toFormat("dd MMMM yyyy", locale: Locales.turkish)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = self.storyboard!.transactionDetail()
    vc.transaction = self.transactions[indexPath.section].data[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension HomeViewController: BWWalkthroughViewControllerDelegate, WalkthroughDelegate {
  // MARK: - Walkthrough delegate -
  func showOnboarding() {
    // Get view controllers and build the walkthrough
    let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
    let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
    let page1 = stb.instantiateViewController(withIdentifier: "walk1")
    let page2 = stb.instantiateViewController(withIdentifier: "walk2")
    let page3 = stb.instantiateViewController(withIdentifier: "walk3") as! AccountViewController
    page3.delegate = self
    
    // Attach the pages to the master
    walkthrough.delegate = self
    walkthrough.add(viewController:page1)
    walkthrough.add(viewController:page2)
    walkthrough.add(viewController:page3)
    
    self.present(walkthrough, animated: true, completion: nil)
  }

  func walkthroughPageDidChange(_ pageNumber: Int) {
  }
  
  func walkthroughCloseButtonPressed() {
    self.closeWalkthrough()
  }

  func closeWalkthrough() {
    self.walkthroughPresented = true
    self.dismiss(animated: true, completion: nil)
    self.fetchTransactions()
  }
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
      let str = "Harcama Bulunamadı"
      let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
      return NSAttributedString(string: str, attributes: attrs)
    }
  
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
      let str = "Hesabınızı ekleyerek harcamalarınızı listeyebilirsiniz"
      let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
      return NSAttributedString(string: str, attributes: attrs)
    }
  
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
      return UIImage(named: "safebox")
    }
  
  func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
    let str = "Hesabınızı Ekleyin"
    let attrs = [
      NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
    ]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
    AccountManager.shared.start(success: {_ in })
  }
}
