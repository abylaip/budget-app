//
//  AddAccountViewController.swift
//  budget-app
//
//  Created by gumball on 5/15/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol accountDelegate: AnyObject {
    func addAccountDelegate(added: Bool)
}

class AddAccountViewController: UIViewController {
    
    let database = Firestore.firestore()
    var uid: String = ""

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var accountAmount: UITextField!
    
    weak var delegate: accountDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
    }
    @IBAction func addAccount(_ sender: Any) {
        let docRef = database.collection("account")
        let accountObject: [String: Any] = [
            "name": accountName.text!,
            "amount": accountAmount.text!,
            "uuid": uid
        ]
        docRef.addDocument(data: accountObject)
        
        let historyRef = database.collection("history")
        let historyObject: [String: Any] = [
            "operation": "Account",
            "name": accountName.text!,
            "money": accountAmount.text!,
            "uuid": uid
        ]
        historyRef.addDocument(data: historyObject)
        
        delegate?.addAccountDelegate(added: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
