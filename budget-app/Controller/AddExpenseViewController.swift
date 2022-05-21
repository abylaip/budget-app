//
//  AddExpenseViewController.swift
//  budget-app
//
//  Created by gumball on 5/15/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol expenseDelegate: AnyObject {
    func addExpenseDelegate(added: Bool)
}

class AddExpenseViewController: UIViewController {
    
    let database = Firestore.firestore()
    var uid: String = ""

    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    
    weak var delegate: expenseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let docRef = database.collection("expenses")
        let accountObject: [String: Any] = [
            "name": expenseName.text!,
            "amount": expenseAmount.text!,
            "uuid": uid
        ]
        docRef.addDocument(data: accountObject)
        delegate?.addExpenseDelegate(added: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
