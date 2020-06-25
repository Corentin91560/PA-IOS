//
//  ProfileViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var assoName: UITextField!
    @IBOutlet var assoMail: UITextField!
    @IBOutlet var assoPhone: UITextField!
    @IBOutlet var assoWebsite: UITextField!
    @IBOutlet var assoSupport: UITextField!
    @IBOutlet var assoAcronyme: UILabel!
    @IBOutlet var disconnectButton: UIButton!
    @IBOutlet var validateButton: UIButton!
    
    var connectedAsso: Association? = nil
    let assoWS: AssociationWebService = AssociationWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        setupTextFields()
        setupNavigationBar()
        setupButtons()
    }
    
    func setupButtons() {
        self.disconnectButton.layer.cornerRadius = disconnectButton.bounds.size.height/2
        self.validateButton.layer.cornerRadius = validateButton.bounds.size.height/2
        self.validateButton.isEnabled = false
    }
    
    func setupNavigationBar() {
        // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Profil"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "pencil"),
        style: .plain,
        target: self,
        action: #selector(Edit))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        // Right item config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "x.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    func setupTextFields () {
        assoName.text = connectedAsso?.name
        assoMail.text = connectedAsso?.email
        assoPhone.text = connectedAsso?.phone
        assoWebsite.text = connectedAsso?.website
        assoSupport.text = connectedAsso?.support
        assoAcronyme.text = connectedAsso?.acronym?.uppercased()
    }
    
    @objc func Edit() {
        assoName.isEnabled = !assoName.isEnabled
        assoMail.isEnabled = !assoMail.isEnabled
        assoPhone.isEnabled = !assoPhone.isEnabled
        assoWebsite.isEnabled = !assoWebsite.isEnabled
        assoSupport.isEnabled = !assoSupport.isEnabled
    }
    
    @objc func Back() {
        let HomeVC = HomeViewController()
        HomeVC.connectedAsso = self.connectedAsso
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func Disconnect(_ sender: Any) {
        let LoginVC = LoginViewController()
        self.navigationController?.pushViewController(LoginVC, animated: true)
    }
    
    @IBAction func Validate(_ sender: Any) {
        
    }
    
    @IBAction func assoNameClicked(_ sender: Any) {
        self.assoName.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoMailClicked(_ sender: Any) {
        self.assoMail.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoPhoneClicked(_ sender: Any) {
        self.assoPhone.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoWebsiteClicked(_ sender: Any) { self.assoWebsite.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoSupportClicked(_ sender: Any) { self.assoSupport.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.validateButton.isEnabled = true
    }
    
    
    
}
