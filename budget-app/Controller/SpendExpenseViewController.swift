//
//  GetExpenseViewController.swift
//  budget-app
//
//  Created by gumball on 5/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol spendDelegate: AnyObject {
    func spendExpenseDelegate(added: Bool)
}

class SpendExpenseViewController: UIViewController {
    
    let database = Firestore.firestore()
    var uid: String = ""
    var amount: String = ""

    @IBOutlet weak var getExpenseName: UITextField!
    @IBOutlet weak var getExpenseAmount: UITextField!
    
    weak var delegate: spendDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }

    }
    
    @IBAction func spendExpense(_ sender: Any) {
        if (getExpenseAmount.text != nil) && (getExpenseName != nil) {
            let accountDocRef = database.collection("account")
            accountDocRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if document.data()["uuid"] as! String == self.uid && document.data()["name"] as! String == self.getExpenseName.text! {
                            let finalAmount = Int(document.data()["amount"] as! String)! - Int(self.getExpenseAmount.text!)!
                            document.reference.updateData(["amount": String(finalAmount)])
                        }
                    }
                }
            }
            
            let historyRef = database.collection("history")
            let historyObject: [String: Any] = [
                "operation": "Expense",
                "name": getExpenseName.text!,
                "money": getExpenseAmount.text!,
                "uuid": uid
            ]
            historyRef.addDocument(data: historyObject)
            
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.delegate?.spendExpenseDelegate(added: true)
            }
        }
    }
}
