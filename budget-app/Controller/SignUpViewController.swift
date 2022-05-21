//
//  SignUpViewController.swift
//  budget-app
//
//  Created by gumball on 5/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let database = Firestore.firestore()
    
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if let error = error as NSError? {
                print(error)
                self.errorMessageLabel.text = "Email or password wrong!"
            } else {
                print("User signs up successfully")
                let user = authResult?.user
                let docRef = self.database.collection("name")
                let incomeObject: [String: Any] = [
                    "name": self.fullnameTextField.text!,
                    "uuid": user!.uid
                ]
                docRef.addDocument(data: incomeObject)
                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(destVC, animated: true, completion: nil)
            }
        }
        
        
    }
}
