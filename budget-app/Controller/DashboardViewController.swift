//
//  DashboardViewController.swift
//  budget-app
//
//  Created by gumball on 5/9/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var incomeCollectionView: UICollectionView!
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    @IBOutlet weak var expensesCollectionView: UICollectionView!
    
    let database = Firestore.firestore()
    
    var uid: String = ""
    var incomeItems: [String] = []
    var incomeMoney: [String] = []
    var accountsItems: [String] = []
    var accountsMoney: [String] = []
    var expensesItems: [String] = []
    var expensesMoney: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
        
        parseIncome()
        parseAccount()
        parseExpense()
        
        self.incomeCollectionView.layer.cornerRadius = 10
        self.accountsCollectionView.layer.cornerRadius = 10
        self.expensesCollectionView.layer.cornerRadius = 10
        
        incomeCollectionView.delegate = self
        incomeCollectionView.dataSource = self
        
        accountsCollectionView.delegate = self
        accountsCollectionView.dataSource = self
        
        expensesCollectionView.delegate = self
        expensesCollectionView.dataSource = self
        
        self.view.addSubview(incomeCollectionView)
        self.view.addSubview(accountsCollectionView)
        self.view.addSubview(expensesCollectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.incomeCollectionView {
            return min(3, incomeItems.count)
        }
        if collectionView == self.accountsCollectionView {
            return min(3, accountsItems.count)
        }
        return min(9, expensesItems.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.incomeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "incomeCell", for: indexPath) as! IncomeCollectionViewCell
            cell.incomeLabel.text = String(incomeItems[indexPath.row])
            cell.incomeMoney.text = "$" + String(incomeMoney[indexPath.row])
            cell.incomeImage.image = UIImage(named: "money")
            cell.incomeImage.clipsToBounds = true
            cell.incomeImage.layer.cornerRadius = cell.incomeImage.frame.height / 2
            return cell
        }
        if collectionView == self.accountsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountsCell", for: indexPath) as! AccountsCollectionViewCell
            cell.accountsLabel.text = accountsItems[indexPath.row]
            cell.accountsMoney.text = "$" + String(accountsMoney[indexPath.row])
            cell.accountsImage.image = UIImage(named: "wallet")
            cell.accountsImage.clipsToBounds = true
            cell.accountsImage.layer.cornerRadius = cell.accountsImage.frame.height / 2
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "expensesCell", for: indexPath) as! ExpensesCollectionViewCell
        cell.expensesLabel.text = expensesItems[indexPath.row]
        cell.expensesMoney.text = "$" + String(expensesMoney[indexPath.row])
        cell.expensesButton.clipsToBounds = true
        cell.expensesButton.layer.cornerRadius = cell.expensesButton.frame.height / 2
        return cell
    }
    
    func parseIncome() {
        incomeMoney.removeAll()
        incomeItems.removeAll()
        let incomeDoc = database.collection("income")
        incomeDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        self.incomeItems.append(document.data()["name"] as! String)
                        self.incomeMoney.append(document.data()["profit"] as! String)
                    }
                    self.incomeCollectionView.reloadData()
                }
            }
        }
    }
    
    func parseAccount() {
        accountsMoney.removeAll()
        accountsItems.removeAll()
        let accountDoc = database.collection("account")
        accountDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        self.accountsItems.append(document.data()["name"] as! String)
                        self.accountsMoney.append(document.data()["amount"] as! String)
                    }
                    self.accountsCollectionView.reloadData()
                }
            }
        }
    }
    
    func parseExpense() {
        expensesMoney.removeAll()
        expensesItems.removeAll()
        let expensesDoc = database.collection("expenses")
        expensesDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        self.expensesItems.append(document.data()["name"] as! String)
                        self.expensesMoney.append(document.data()["amount"] as! String)
                    }
                    self.expensesCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func toAddIncome(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "AddIncomeViewController") as! AddIncomeViewController
        dest.delegate = self
        dest.modalPresentationStyle = .pageSheet
        present(dest, animated: true)
    }
    
    @IBAction func toAddAccount(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "AddAccountViewController") as! AddAccountViewController
        dest.delegate = self
        dest.modalPresentationStyle = .pageSheet
        present(dest, animated: true)
    }
    
    @IBAction func toAddExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "AddExpenseViewController") as! AddExpenseViewController
        dest.delegate = self
        dest.modalPresentationStyle = .pageSheet
        present(dest, animated: true)
    }
    
    @IBAction func getExpense(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "SpendExpenseViewController") as! SpendExpenseViewController
        dest.delegate = self
        dest.modalPresentationStyle = .pageSheet
        present(dest, animated: true)
    }
    
}

extension DashboardViewController: incomeDelegate, accountDelegate, expenseDelegate, spendDelegate {
    func spendExpenseDelegate(added: Bool) {
        if added == true {
            parseAccount()
            parseExpense()
        }
    }
    
    func addExpenseDelegate(added: Bool) {
        if added == true {
            parseExpense()
        }
    }
    
    func addAccountDelegate(added: Bool) {
        if added == true {
            parseAccount()
        }
    }
    
    func addIncomeDelegate(added: Bool) {
        if added == true {
            parseIncome()
        }
    }
}
