//
//  ProfileViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var assoName: UITextField!
    @IBOutlet var assoMail: UITextField!
    @IBOutlet var assoPhone: UITextField!
    @IBOutlet var assoWebsite: UITextField!
    @IBOutlet var assoSupport: UITextField!
    @IBOutlet var assoAcronyme: UITextField!
    @IBOutlet var disconnectButton: UIButton!
    @IBOutlet var validateButton: UIButton!
    @IBOutlet var changeImage: UIButton!
    @IBOutlet var deleteAsso: UIButton!
    @IBOutlet var errorTextField: UILabel!
    
    var connectedAsso: Association? = nil
    let assoWS: AssociationWebService = AssociationWebService()
    let postWS: PostWebService = PostWebService()
    let eventWS: EventWebService = EventWebService()
    let userWS: UserWebService = UserWebService()
    
    var imagePicker: UIImagePickerController!
    var logoChanged: Bool = false
    class func newInstance(connectedAsso : Association?) -> ProfileViewController {
        let ProfileVC: ProfileViewController = ProfileViewController()
        ProfileVC.connectedAsso = connectedAsso
        return ProfileVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        self.changeImage.isUserInteractionEnabled = false
        self.deleteAsso.isHidden = true
        self.assoLogo.load(url: URL(string: (connectedAsso?.logo)!)!)
        self.assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        self.assoLogo.layer.cornerRadius = 25
        setupPicker()
        setupTextFields()
        setupNavigationBar()
        setupButtons()
    }
    
    func setupPicker() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
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
        image: UIImage(named: "SF_pencil_tip_crop_circle_badge_plus"),
        style: .plain,
        target: self,
        action: #selector(Edit))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        // Right item config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
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
        assoAcronyme.text = connectedAsso?.acronym
    }
    
    @objc func Edit() {
        self.assoName.isEnabled = !self.assoName.isEnabled
        self.assoMail.isEnabled = !self.assoMail.isEnabled
        self.assoPhone.isEnabled = !self.assoPhone.isEnabled
        self.assoWebsite.isEnabled = !self.assoWebsite.isEnabled
        self.assoSupport.isEnabled = !self.assoSupport.isEnabled
        self.assoAcronyme.isEnabled = !self.assoAcronyme.isEnabled
        self.changeImage.isUserInteractionEnabled = !self.changeImage.isUserInteractionEnabled
        self.deleteAsso.isHidden = !self.deleteAsso.isHidden
    }
    
    @objc func Back() {
        let HomeVC = HomeViewController()
        HomeVC.connectedAsso = self.connectedAsso
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func Disconnect(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Déconnexion", message: "Voulez vous vraiment vous déconnecter ?", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
            let keychain = KeychainSwift()
            keychain.clear()
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true) {}
        }))
        present(deleteAlert, animated: true, completion: nil)
       
    }
    
    @IBAction func Validate(_ sender: Any) {
        let newAsso = Association(name: assoName.text!, email: assoMail.text!, password: connectedAsso!.password)
        newAsso.acronym = assoAcronyme.text
        newAsso.idAssociation = connectedAsso?.idAssociation!
        newAsso.idCategory = connectedAsso?.idCategory!
        newAsso.logo = connectedAsso?.logo
        newAsso.phone = assoPhone.text!
        newAsso.support = assoSupport.text!
        newAsso.website = assoWebsite.text!
        if(logoChanged) {
            AppConfig.cloudinary.createUploader().upload(data: (self.assoLogo.image?.pngData())!, uploadPreset: "vwvkhj98") { result, error in
                newAsso.logo = result?.url!
                self.updateAsso(newAsso: newAsso)
            }
        } else {
            newAsso.logo = connectedAsso?.logo
            self.updateAsso(newAsso: newAsso)
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updateAsso(newAsso: Association){
        var checkCallback = false
        self.assoWS.updateAsso(asso: newAsso) { (sucess) in
            if (sucess || checkCallback) {
                checkCallback = true
                self.connectedAsso = newAsso
                self.postWS.getPosts(idAsso: (self.connectedAsso?.idAssociation)!) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso!.idAssociation!) { (events) in
                        self.userWS.getUsersByIdAsso(idAsso: self.connectedAsso!.idAssociation!) { (users) in
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, connectedAsso: self.connectedAsso, events: events,users: users), animated: false)
                        }
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    self.errorTextField.isHidden = false
                }
            }
        }
    }
    
    @IBAction func deleteAsso(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Suppression", message: "Etes vous sur de vouloir supprimer votre compte ?", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
            self.delete()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true) {}
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func delete() {
        var checkCallback = false
        self.assoWS.deleteAsso(idAsso: connectedAsso!.idAssociation!) { (sucess) in
            DispatchQueue.main.sync {
                if (sucess || checkCallback) {
                    UserDefaults.standard.removeObject(forKey: "userEmail")
                    UserDefaults.standard.removeObject(forKey: "userPassword")
                    UserDefaults.standard.synchronize()
                    checkCallback = true
                    print("GO LOGIN")
                    self.navigationController?.pushViewController(LoginViewController(), animated: false)
                } else {
                    self.errorTextField.text = "Suppression impossible !"
                    self.errorTextField.isHidden = false
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.assoLogo.image = pickedImage
            self.logoChanged = true
            self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
            self.errorTextField.isHidden = true
            self.validateButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assoNameClicked(_ sender: Any) {
        self.assoName.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoMailClicked(_ sender: Any) {
        self.assoMail.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoPhoneClicked(_ sender: Any) {
        self.assoPhone.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoWebsiteClicked(_ sender: Any) {
        self.assoWebsite.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoSupportClicked(_ sender: Any) {
        self.assoSupport.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
    @IBAction func assoAcronymeClicked(_ sender: Any) {
        self.assoAcronyme.text = ""
        self.validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTextField.isHidden = true
        self.validateButton.isEnabled = true
    }
    
}
