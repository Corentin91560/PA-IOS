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
    @IBOutlet var errorTF: UILabel!
    
    let assoWS : AssociationWebService = AssociationWebService()
    
    override func viewDidLoad() {
        SigninButton.layer.cornerRadius = SigninButton.bounds.size.height/2
        navigationItem.hidesBackButton = true
        errorTF.isHidden = true
        super.viewDidLoad()
    }
    
    @IBAction func Signup(_ sender: Any) {
        let signupForm = SignupViewController()
        self.navigationController?.pushViewController(signupForm, animated: true)
        
    }
    
    @IBAction func Login (_ sender: Any) {
        let email = MailTF.text!
        let pwd = PasswordTF.text!
        self.assoWS.Login(mail: email, password: pwd) { (asso) in
            if(asso.count > 0) {
                let Home = HomeViewController()
                Home.connectedAsso = asso[0]
                self.navigationController?.pushViewController(Home, animated: true)
            } else {
                self.errorTF.isHidden = false
            }
        }
    }
    @IBAction func mailTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
    
    @IBAction func passwordTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
    
}

