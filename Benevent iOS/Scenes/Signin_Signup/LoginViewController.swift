//
//  LoginViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        setupView()
    }
    
    func setupView() {
        self.activityIndicator.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "systemGray6")
        self.navigationItem.hidesBackButton = true
        self.loginButton.layer.cornerRadius = loginButton.bounds.size.height/2
        self.errorTF.isHidden = true
    }
    
    @IBAction func Login (_ sender: Any) {
        self.activityIndicator.startLoading()
        self.assoWS.Login(mail: self.emailTF.text!, password: self.passwordTF.text!) { (asso) in
            if(asso.count > 0) {
                self.postWS.getPosts(idAsso: asso[0].idas!) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: asso[0].idas!) { (events) in
                        self.userWS.getUsers { (users) in
                            UserDefaults.standard.set(asso[0].email, forKey: "userEmail")
                            UserDefaults.standard.set(asso[0].password, forKey: "userPassword")
                            UserDefaults.standard.synchronize()
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, connectedAsso: asso[0],events: events, users: users), animated: true)
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
            let signupForm = SignupViewController.newInstance(categories: categories)
            self.navigationController?.pushViewController(signupForm, animated: true)
        }
        
    }
    
    @IBAction func mailTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
    
    @IBAction func passwordTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
    }
}

