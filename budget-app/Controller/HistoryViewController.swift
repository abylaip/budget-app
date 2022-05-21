//
//  HistoryViewController.swift
//  budget-app
//
//  Created by gumball on 5/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var historyName: [String] = []
    var historyMoney: [String] = []
    var historyOperation: [String] = []
    
    let database = Firestore.firestore()
    
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
        
        parseHistory()
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        historyTableView.addSubview(refreshControl)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        self.historyTableView.rowHeight = 80
    }
    
    @objc func refresh(_ sender: AnyObject) {
        parseHistory()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        cell.historyExpense.text = historyName[indexPath.row]
        cell.historyAccount.text = historyOperation[indexPath.row]
        if historyOperation[indexPath.row] == "Expense" {
            cell.historyMoney.text = "-" + " $" + String(historyMoney[indexPath.row])
        } else {
            cell.historyMoney.text = "+" + " $" + String(historyMoney[indexPath.row])
        }
        if historyOperation[indexPath.row] == "Expense" {
            cell.historyImage.image = UIImage(named:"expense")
            cell.historyImage.backgroundColor = #colorLiteral(red: 1, green: 0.3078337368, blue: 0.3917612875, alpha: 1)
        } else if historyOperation[indexPath.row] == "Income" {
            cell.historyImage.image = UIImage(named: "money")
            cell.historyImage.backgroundColor = #colorLiteral(red: 0.2266526564, green: 1, blue: 0.8815250672, alpha: 1)
        } else if historyOperation[indexPath.row] == "Account" {
            cell.historyImage.image = UIImage(named: "wallet")
            cell.historyImage.backgroundColor = #colorLiteral(red: 0.3261020191, green: 0.3161286634, blue: 1, alpha: 1)
        }
        cell.historyImage.clipsToBounds = true
        cell.historyImage.layer.cornerRadius = cell.historyImage.frame.height / 2
        return cell
    }
    
    func parseHistory() {
        historyName.removeAll()
        historyMoney.removeAll()
        historyOperation.removeAll()
        let expensesDoc = database.collection("history")
        expensesDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        self.historyName.append(document.data()["name"] as! String)
                        self.historyMoney.append(document.data()["money"] as! String)
                        self.historyOperation.append(document.data()["operation"] as! String)
                    }
                    self.historyTableView.reloadData()
                }
            }
        }
    }
}
