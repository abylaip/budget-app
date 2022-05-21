//
//  ProfileViewController.swift
//  budget-app
//
//  Created by gumball on 5/17/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    let database = Firestore.firestore()
    
    var uid: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.uid = user.uid
            self.emailLabel.text = user.email!
        }
        
        parseUser()
    }
    
    func parseUser() {
        print(self.uid)
        let nameDoc = database.collection("name")
        nameDoc.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["uuid"] as! String == self.uid {
                        self.nameLabel.text = document.data()["name"]  as? String
                    }
                }
            }
        }
    }
    
}
