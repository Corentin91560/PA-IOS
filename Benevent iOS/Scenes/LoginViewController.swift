//
//  LoginViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet var BasicLoginButton: UIButton!
    @IBOutlet var FBLoginButton: FBLoginButton!
    @IBOutlet var MailTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    
    let BeneventWS: BeneventWebService = BeneventWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBLoginButton.permissions = ["public_profile","email"]
        FBLoginButton.delegate = self

        if (FBSDKLoginKit.AccessToken.isCurrentAccessTokenActive) {
            let Home = HomeViewController()
            self.navigationController?.pushViewController(Home, animated: true)
        }
    }
    
    @IBAction func BasicLogin (_ sender: Any) {
        let email = MailTF.text!
        let pwd = PasswordTF.text!
        self.BeneventWS.Login(mail: email, password: pwd) { (user) in
            let Home = HomeViewController()
            Home.connectedUser = user[0]
            Home.connectedWithFB = 0
            self.navigationController?.pushViewController(Home, animated: true)
        }
    }
    
    // FB LOGIN (MUST BE HERE TO RESPECT THE INTERFACE)
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let Home = HomeViewController()
        self.navigationController?.pushViewController(Home, animated: true)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}
       
}
