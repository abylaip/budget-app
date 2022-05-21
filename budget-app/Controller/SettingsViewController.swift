//
//  SettingsViewController.swift
//  budget-app
//
//  Created by gumball on 5/9/22.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toProfile(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        dest.modalPresentationStyle = .pageSheet
        present(dest, animated: true)
    }
    
    @IBAction func exit(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        dest.modalPresentationStyle = .fullScreen
        present(dest, animated: true)
    }
    
}
