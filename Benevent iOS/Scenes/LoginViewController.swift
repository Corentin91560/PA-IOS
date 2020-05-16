//
//  LoginViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //if let token = AccessToken.current, !token.isExpired {
           
        //} else {
            let loginButton = FBLoginButton()
            loginButton.center = view.center
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
        //}
    }
}
