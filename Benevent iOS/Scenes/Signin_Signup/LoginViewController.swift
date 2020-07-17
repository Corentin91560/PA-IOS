//
//  LoginViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let assoWS : AssociationWebService = AssociationWebService()
    let postWS: PostWebService = PostWebService()
    let eventWS: EventWebService = EventWebService()
    let categoryWS: CategoryWebService = CategoryWebService()
    let userWS: UserWebService = UserWebService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        passwordTF.delegate = self
        if #available(iOS 12.0, *) {
            passwordTF.textContentType = .oneTimeCode
        }
        self.activityIndicator.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "systemGray6")
        self.navigationItem.hidesBackButton = true
        self.loginButton.layer.cornerRadius = loginButton.bounds.size.height/2
        self.errorTF.isHidden = true
    }
    
    @IBAction func Login (_ sender: Any) {
        self.activityIndicator.startLoading()
        self.assoWS.Login(mail: self.emailTF.text!, password: self.passwordTF.text!.md5()) { (asso) in
            if(asso.count > 0) {
                self.postWS.getPosts(idAsso: asso[0].idAssociation!) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: asso[0].idAssociation!) { (events) in
                        self.userWS.getUsersByIdAsso(idAsso: asso[0].idAssociation!) { (users) in
                            let keychain = KeychainSwift()
                            keychain.set(asso[0].email, forKey: "userEmail")
                            keychain.set(asso[0].password, forKey: "userPassword")
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, connectedAsso: asso[0], events: events, users: users), animated: true)
                        }
                    }
                }
            } else {
                self.activityIndicator.stopLoading()
                self.errorTF.isHidden = false
            }
        }
    }
    
    @IBAction func Signup(_ sender: Any) {
        self.categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(SignupViewController.newInstance(categories: categories), animated: true)
        }
    }
    
    @IBAction func mailTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
    
    @IBAction func passwordTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
      if (textField == passwordTF && !textField.isSecureTextEntry) {
            textField.isSecureTextEntry = true
        }
        return true
    }
}

