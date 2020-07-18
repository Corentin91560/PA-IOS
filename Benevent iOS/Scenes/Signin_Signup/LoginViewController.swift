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
    
    private let assoWS : AssociationWebService = AssociationWebService()
    private let postWS: PostWebService = PostWebService()
    private let eventWS: EventWebService = EventWebService()
    private let categoryWS: CategoryWebService = CategoryWebService()
    private let userWS: UserWebService = UserWebService()
    
    @IBOutlet private var errorTF: UILabel!
    @IBOutlet private var emailTF: UITextField!
    @IBOutlet private var passwordTF: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var signupButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        passwordTF.delegate = self
        activityIndicator.isHidden = true
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.barTintColor = UIColor(named: "systemGray6")
        navigationItem.hidesBackButton = true
        loginButton.layer.cornerRadius = loginButton.bounds.size.height/2
        errorTF.isHidden = true
    }
    
    @IBAction private func Login (_ sender: Any) {
        activityIndicator.startLoading()
        assoWS.Login(mail: emailTF.text!, password: passwordTF.text!.md5()) { (asso) in
            if(asso.count > 0) {
                self.postWS.getPosts(idAsso: asso[0].getIdAssociation()) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: asso[0].getIdAssociation()) { (events) in
                        self.userWS.getUsersByIdAsso(idAsso: asso[0].getIdAssociation()) { (users) in
                            AppConfig.keychain.set(asso[0].getEmail(), forKey: "userEmail")
                            AppConfig.keychain.set(self.passwordTF.text!.md5(), forKey: "userPassword")
                            AppConfig.connectedAssociation = asso[0]
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, events: events, users: users), animated: true)
                        }
                    }
                }
            } else {
                self.activityIndicator.stopLoading()
                self.errorTF.isHidden = false
            }
        }
    }
    
    @IBAction private func Signup(_ sender: Any) {
        categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(SignupViewController.newInstance(categories: categories), animated: true)
        }
    }
    
    @IBAction private func mailTFClicked(_ sender: Any) {
        errorTF.isHidden = true
    }
    
    @IBAction private func passwordTFClicked(_ sender: Any) {
        passwordTF.text = ""
        errorTF.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
      if (textField == passwordTF && !textField.isSecureTextEntry) {
            textField.isSecureTextEntry = true
        }
        return true
    }
}

