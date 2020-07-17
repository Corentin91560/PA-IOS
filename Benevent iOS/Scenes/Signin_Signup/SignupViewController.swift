//
//  SignupViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import Cloudinary

class SignupViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var assoNameTF: UITextField!
    @IBOutlet var assoEmailTF: UITextField!
    @IBOutlet var assoPasswordTF: UITextField!
    @IBOutlet var assoCategoryTF: UITextField!
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var nullErrorTF: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var chooseImage: UIButton!
    
    let assoWS: AssociationWebService = AssociationWebService()
    
    var categories: [Category]!
    var categoriesNames: [String]? = nil
    var selectedCategory: Category!
    var categoryPicker: UIPickerView!
    var imagePicker: UIImagePickerController!
    
    class func newInstance(categories: [Category]) -> SignupViewController {
        let SignUpVC: SignupViewController = SignupViewController()
        SignUpVC.categories = categories
        return SignUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.assoLogo.image = UIImage(named: "AppIconImage")
        self.assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        self.activityIndicator.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardWhenTappedAround()
        setupPicker()
        errorTF.isHidden = true
        assoCategoryTF.delegate = self
        signupButton.layer.cornerRadius = signupButton.bounds.height/2
    }
    
    func setupPicker() {
        // Category Picker
        self.categoryPicker = UIPickerView()
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        if(categories.isEmpty) {
            self.assoCategoryTF.isEnabled = false
        } else {
            self.categoriesNames = categories.map{ $0.name }
            self.assoCategoryTF.inputView = categoryPicker
            self.assoCategoryTF.text = self.categoriesNames?[0]
            self.selectedCategory = categories[0]
        }
        // Image Picker
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func Confirm(_ sender: Any) {
        if (self.assoNameTF.text == "" || self.assoEmailTF.text == "" || self.assoPasswordTF.text == "" ) {
            self.nullErrorTF.isHidden = false
        } else if (self.assoPasswordTF.text!.count < 6) {
            self.errorTF.text = "Votre mot de passe doit contenir au moins 6 caractères !"
            self.errorTF.isHidden = false
        } else if (self.assoCategoryTF.text == "") {
            self.errorTF.text = "Vous n'êtes pas connecté à internet"
            self.errorTF.isHidden = false
        } else {
            self.activityIndicator.startLoading()
            AppConfig.cloudinary.createUploader().upload(data: (self.assoLogo.image?.pngData())!, uploadPreset: "vwvkhj98") { result, error in
                self.assoWS.Signup(name: self.assoNameTF.text!, email: self.assoEmailTF.text!, password: self.assoPasswordTF.text!.md5(), profilePicture: result?.url ?? "", idCategory: self.selectedCategory.idCategory! ) { (sucess) in
                    DispatchQueue.main.async {
                        if(sucess) {
                            self.navigationController?.pushViewController(LoginViewController(), animated: false)
                        } else {
                            print(self.assoNameTF.text!)
                            print(self.assoEmailTF.text!)
                            print(self.assoPasswordTF.text!.md5())
                            print(result?.url ?? "")
                            print(self.selectedCategory.idCategory!)
                            self.activityIndicator.stopLoading()
                            self.errorTF.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func Connect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.assoLogo.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  categoriesNames!.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesNames![row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assoCategoryTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == assoCategoryTF {
               let allowedCharacters = CharacterSet(charactersIn:"")//Here change this characters based on your requirement
               let characterSet = CharacterSet(charactersIn: string)
               return allowedCharacters.isSuperset(of: characterSet)
           }
           return true
    }
    
    @IBAction func nameTFClicked(_ sender: Any) {
        self.activityIndicator.stopLoading()
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
    
    @IBAction func mailTFClicked(_ sender: Any) {
        self.activityIndicator.stopLoading()
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
    
    @IBAction func pwdTFClicked(_ sender: Any) {
        self.activityIndicator.stopLoading()
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
    
}

