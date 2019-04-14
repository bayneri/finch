//
//  ProfileViewController.swift
//  kt-invent-ios
//
//  Created by Mustafa Enes Cakir on 13.04.2019.
//  Copyright © 2019 EnesCakir. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class AssistantViewController: UIViewController {
  
  @IBOutlet weak var cardView: CardView!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tipBottomConstraint: NSLayoutConstraint!
  var tips:[(String, String, Int, Float)] = [
    ("Oyuncak", "baby", 40, Float.random(in: 0 ..< 1))
  ]
  
  var goals:[(String, String, String, Int)] = [
    (AssistantViewController.getTip(category: "Kafe & Restoran", old:20, new:30), "Kafe & Restoran", "drinks", 20),
    (AssistantViewController.getTip(category: "Benzin", old:200, new:280), "Benzin", "fuel", 200),
    (AssistantViewController.getTip(category: "Kişisel Bakım", old:40, new:50), "Kişisel Bakım", "cosmetics", 35)
  ]
  var currentGoal:(String, String, String, Int)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGoal(goal: getNextGoal())

    yesButton.addBorder(color: UIColor.white, weight: 2)
    yesButton.roundCorners(radius: 18, corners: [.layerMinXMaxYCorner])
    
    noButton.addBorder(color: UIColor.white, weight: 2)
    noButton.roundCorners(radius: 18, corners: [.layerMaxXMaxYCorner])

    tableView.tableFooterView = UIView()

  }
  
  static func getTip(category:String, old:Int, new:Int) -> String {
    return "Geçen ay \(category) kategorisinde \(old) TL harcama yaptın. Bu ay bu harcama kategorisinde daha fazla harcama yaparak \(new) TL harcama yaptın. Senin için hedef oluşturmamı ister misin?"
  }
  
  func setupGoal(goal: (String, String, String, Int)?) {
    guard let goal = goal else {
      cardView.backgroundColor = UIColor(hexString: "#46CC7A")
      UIView.transition(with: self.tipLabel,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: { [weak self] in
                          self?.tipLabel.text = "Mükemmel ilerliyorsunuz. Yeni tavsiyeler için aktif hedeflerinizi tamamlayın"
        }, completion: nil)

      yesButton.removeFromSuperview()
      noButton.removeFromSuperview()
      tipBottomConstraint.constant = 10
      self.loadViewIfNeeded()
      return
    }
    
    currentGoal = goal
    UIView.transition(with: self.tipLabel,
                      duration: 0.25,
                      options: .transitionCrossDissolve,
                      animations: { [weak self] in
                        self?.tipLabel.text = self?.currentGoal!.0
      }, completion: nil)
  }
  
  func getNextGoal() -> (String, String, String, Int)?  {
    if goals.isEmpty {
      return nil
    }
    return goals.removeFirst()
  }
  
  // MARK: - Actions
  
  @IBAction func yesAction(_ sender: Any) {
    self.tips.insert((currentGoal!.1, currentGoal!.2, currentGoal!.3, 0.05), at: 0)
    self.tableView.reloadSections(IndexSet([0]), with: .automatic)
    setupGoal(goal: getNextGoal())
  }
  
  @IBAction func noAction(_ sender: Any) {
    setupGoal(goal: getNextGoal())
  }
}

extension AssistantViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tips.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! TipTableViewCell
    cell.setTip(tip: tips[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let vc = self.storyboard!.transactionDetail()
//    vc.transaction = self.transactions[indexPath.row]
//    navigationController?.pushViewController(vc, animated: true)
  }
}
