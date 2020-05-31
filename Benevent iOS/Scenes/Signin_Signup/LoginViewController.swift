//
//  LoginViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var SigninButton: UIButton!
    @IBOutlet var SignupButton: UIButton!
    @IBOutlet var MailTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    let BeneventWS: BeneventWebService = BeneventWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Signup(_ sender: Any) {
        let signupForm = SignupViewController()
        self.navigationController?.pushViewController(signupForm, animated: true)
        
    }
    
    @IBAction func BasicLogin (_ sender: Any) {
        let email = MailTF.text!
        let pwd = PasswordTF.text!
        self.BeneventWS.Login(mail: email, password: pwd) { (asso) in
            let Home = HomeViewController()
            Home.connectedAsso = asso[0]
            self.navigationController?.pushViewController(Home, animated: true)
        }
    }
}

