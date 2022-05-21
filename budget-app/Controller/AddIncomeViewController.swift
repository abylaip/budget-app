//
//  AddIncomeViewController.swift
//  budget-app
//
//  Created by gumball on 5/15/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol incomeDelegate: AnyObject {
    func addIncomeDelegate(added: Bool)
}

class AddIncomeViewController: UIViewController {

    let database = Firestore.firestore()
    var uid: String = ""
    var collectionView: UICollectionView!
    weak var delegate: incomeDelegate?
    
    @IBOutlet weak var incomeName: UITextField!
    @IBOutlet weak var incomeProfit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
        }
    }
    
    @IBAction func addIncome(_ sender: Any) {
        let docRef = database.collection("income")
        let incomeObject: [String: Any] = [
            "name": incomeName.text!,
            "profit": incomeProfit.text!,
            "uuid": uid
        ]
        docRef.addDocument(data: incomeObject)
        
        let historyRef = database.collection("history")
        let historyObject: [String: Any] = [
            "operation": "Income",
            "name": incomeName.text!,
            "money": incomeProfit.text!,
            "uuid": uid
        ]
        historyRef.addDocument(data: historyObject)
        
        delegate?.addIncomeDelegate(added: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
