//
//  ProfileViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let assoWS: AssociationWebService = AssociationWebService()
    private let postWS: PostWebService = PostWebService()
    private let eventWS: EventWebService = EventWebService()
    private let userWS: UserWebService = UserWebService()
    
    private var connectedAsso: Association!
    
    @IBOutlet private var assoLogo: UIImageView!
    @IBOutlet private var assoName: UITextField!
    @IBOutlet private var assoMail: UITextField!
    @IBOutlet private var assoPhone: UITextField!
    @IBOutlet private var assoWebsite: UITextField!
    @IBOutlet private var assoSupport: UITextField!
    @IBOutlet private var assoAcronyme: UITextField!
    @IBOutlet private var disconnectButton: UIButton!
    @IBOutlet private var validateButton: UIButton!
    @IBOutlet private var changeImage: UIButton!
    @IBOutlet private var deleteAsso: UIButton!
    @IBOutlet private var errorTextField: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var imagePicker: UIImagePickerController!
    private var logoChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedAsso = AppConfig.connectedAssociation
        setupView()
    }
    
    private func setupView() {
        hideKeyboardWhenTappedAround()
        changeImage.isUserInteractionEnabled = false
        deleteAsso.isHidden = true
        assoLogo.load(url: URL(string: connectedAsso.getLogo())!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        assoLogo.layer.cornerRadius = 25
        activityIndicator.isHidden = true
        setupPicker()
        setupTextFields()
        setupNavigationBar()
        setupButtons()
    }
    
    private func setupPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    private func setupButtons() {
        disconnectButton.layer.cornerRadius = disconnectButton.bounds.size.height/2
        validateButton.layer.cornerRadius = validateButton.bounds.size.height/2
        validateButton.isEnabled = false
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Profil"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "SF_pencil_tip_crop_circle_badge_plus"),
        style: .plain,
        target: self,
        action: #selector(Edit))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    private func setupTextFields () {
        assoName.delegate = self
        assoMail.delegate = self
        assoPhone.delegate = self
        assoWebsite.delegate = self
        assoSupport.delegate = self
        assoAcronyme.delegate = self
        assoName.text = connectedAsso.getName()
        assoMail.text = connectedAsso.getEmail()
        assoPhone.text = connectedAsso.getPhone()
        assoWebsite.text = connectedAsso.getWebsite()
        assoSupport.text = connectedAsso.getSupport()
        assoAcronyme.text = connectedAsso.getAcronym()
    }
    
    private func delete() {
        var checkCallback = false
        assoWS.deleteAsso(idAsso: connectedAsso!.getIdAssociation()) { (sucess) in
            DispatchQueue.main.sync {
                if (sucess || checkCallback) {
                    AppConfig.keychain.clear()
                    checkCallback = true
                    self.navigationController?.pushViewController(LoginViewController(), animated: false)
                } else {
                    self.errorTextField.text = "Suppression impossible !"
                    self.errorTextField.isHidden = false
                }
            }
        }
    }
    
    private func updateAsso(newAsso: Association){
        var checkCallback = false
        assoWS.updateAsso(asso: newAsso) { (sucess) in
            if (sucess || checkCallback) {
                checkCallback = true
                AppConfig.connectedAssociation = newAsso
                self.postWS.getPosts(idAsso: self.connectedAsso.getIdAssociation()) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso.getIdAssociation()) { (events) in
                        self.userWS.getUsersByIdAsso(idAsso: self.connectedAsso.getIdAssociation()) { (users) in
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, events: events,users: users), animated: false)
                        }
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    self.activityIndicator.stopLoading()
                    self.errorTextField.isHidden = false
                }
            }
        }
    }
    
    @objc private func Edit() {
       assoName.isEnabled = !self.assoName.isEnabled
       assoMail.isEnabled = !self.assoMail.isEnabled
       assoPhone.isEnabled = !self.assoPhone.isEnabled
       assoWebsite.isEnabled = !self.assoWebsite.isEnabled
       assoSupport.isEnabled = !self.assoSupport.isEnabled
       assoAcronyme.isEnabled = !self.assoAcronyme.isEnabled
       changeImage.isUserInteractionEnabled = !self.changeImage.isUserInteractionEnabled
       deleteAsso.isHidden = !self.deleteAsso.isHidden
    }
    
    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }

    @IBAction private func Disconnect(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Déconnexion", message: "Voulez vous vraiment vous déconnecter ?", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
            AppConfig.keychain.clear()
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true) {}
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction private func Validate(_ sender: Any) {
        if (assoName.text == "" ||  assoMail.text == "") {
            errorTextField.text = "Les champs 'Nom' et 'Email' sont obligatoires ! "
            errorTextField.isHidden = false
        } else if (!assoMail.text!.isValidEmail()) {
            errorTextField.text = "Une adresse mail valide est obligatoire ! "
            errorTextField.isHidden = false
        } else {
            activityIndicator.startLoading()
            let newAsso = Association(name: assoName.text!, email: assoMail.text!, password: AppConfig.keychain.get("userPassword")!)
            newAsso.setAcronym(acronym: assoAcronyme.text)
            newAsso.setIdAssociation(idAssociation: connectedAsso.getIdAssociation())
            newAsso.setIdCategory(idCategory: connectedAsso.getIdCategory())
            newAsso.setLogo(logo: connectedAsso.getLogo())
            newAsso.setPhone(phone: assoPhone.text!)
            newAsso.setSupport(support: assoSupport.text!)
            newAsso.setWebsite(website: assoWebsite.text!)
            if(logoChanged) {
                AppConfig.cloudinary.createUploader().upload(data: (self.assoLogo.image?.pngData())!, uploadPreset: "vwvkhj98") { result, error in
                    newAsso.setLogo(logo: (result?.url!)!)
                    self.updateAsso(newAsso: newAsso)
                }
            } else {
                newAsso.setLogo(logo: connectedAsso.getLogo())
                self.updateAsso(newAsso: newAsso)
            }
        }
    }
    
    @IBAction private func chooseImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func deleteAsso(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Suppression", message: "Etes vous sur de vouloir supprimer votre compte ?", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
            self.delete()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true) {}
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction private func assoNameClicked(_ sender: Any) {
        validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTextField.isHidden = true
        validateButton.isEnabled = true
    }
    
    @IBAction private func assoMailClicked(_ sender: Any) {
        validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTextField.isHidden = true
        validateButton.isEnabled = true
    }
    
    @IBAction private func assoPhoneClicked(_ sender: Any) {
        validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTextField.isHidden = true
        validateButton.isEnabled = true
    }
    
    @IBAction private func assoWebsiteClicked(_ sender: Any) {
        validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTextField.isHidden = true
        validateButton.isEnabled = true
    }
    
    @IBAction private func assoSupportClicked(_ sender: Any) {
        validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTextField.isHidden = true
        validateButton.isEnabled = true
    }
    
    @IBAction private func assoAcronymeClicked(_ sender: Any) {
       validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
       errorTextField.isHidden = true
       validateButton.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            assoLogo.image = pickedImage
            logoChanged = true
            validateButton.backgroundColor = UIColor(named: "BackgroundGreen")
            errorTextField.isHidden = true
            validateButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case assoName:
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoMail:
            let maxLength = 250
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoPhone:
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return (allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength)
        case assoWebsite:
            let maxLength = 250
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoSupport:
            let maxLength = 250
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoAcronyme:
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            return true
        }
    }
}
