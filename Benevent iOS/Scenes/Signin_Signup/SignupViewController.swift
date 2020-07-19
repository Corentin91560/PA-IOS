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

    private let assoWS: AssociationWebService = AssociationWebService()
    
    private var categories: [Category]!
    
    @IBOutlet private var assoNameTF: UITextField!
    @IBOutlet private var assoEmailTF: UITextField!
    @IBOutlet private var assoPasswordTF: UITextField!
    @IBOutlet private var assoCategoryTF: UITextField!
    @IBOutlet private var errorTF: UILabel!
    @IBOutlet private var signupButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var nullErrorTF: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var assoLogo: UIImageView!
    @IBOutlet private var chooseImage: UIButton!
    
    private var categoriesNames: [String]? = nil
    private var selectedCategory: Category!
    private var categoryPicker: UIPickerView!
    private var imagePicker: UIImagePickerController!
    
    class func newInstance(categories: [Category]) -> SignupViewController {
        let SignUpVC: SignupViewController = SignupViewController()
        SignUpVC.categories = categories
        return SignUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.hidesBackButton = true
        assoLogo.image = UIImage(named: "AppIconImage")
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        activityIndicator.isHidden = true
        errorTF.isHidden = true
        assoCategoryTF.delegate = self
        signupButton.layer.cornerRadius = signupButton.bounds.height/2
        hideKeyboardWhenTappedAround()
        setupPicker()
    }
    
    private func setupPicker() {
        // Category Picker
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        if(categories.isEmpty) {
            assoCategoryTF.isEnabled = false
        } else {
            categoriesNames = categories.map{ $0.getName() }
            assoCategoryTF.inputView = categoryPicker
            assoCategoryTF.text = self.categoriesNames?[0]
            selectedCategory = categories[0]
        }
        // Image Picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    @IBAction private func chooseImage(_ sender: Any) {
       imagePicker.allowsEditing = false
       imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func Validate(_ sender: Any) {
        if (assoNameTF.text == "" || assoEmailTF.text == "" || assoPasswordTF.text == "" ) {
            nullErrorTF.isHidden = false
        } else if (!assoEmailTF.text!.isValidEmail()) {
            errorTF.text = "Une adresse mail valide est obligatoire ! "
            errorTF.isHidden = false
        } else if (assoPasswordTF.text!.count < 6) {
            errorTF.text = "Votre mot de passe doit contenir au moins 6 caractères !"
            errorTF.isHidden = false
        } else if (assoCategoryTF.text == "") {
            errorTF.text = "Vous n'êtes pas connecté à internet"
            errorTF.isHidden = false
        } else {
            activityIndicator.startLoading()
            AppConfig.cloudinary.createUploader().upload(data: (self.assoLogo.image?.pngData())!, uploadPreset: AppConfig.cloudinaryUploadPreset) { result, error in
                self.assoWS.Signup(name: self.assoNameTF.text!, email: self.assoEmailTF.text!, password: self.assoPasswordTF.text!.md5(), profilePicture: result?.url ?? "", idCategory: self.selectedCategory.getIdCategory() ) { (sucess) in
                    DispatchQueue.main.async {
                        if(sucess) {
                            self.navigationController?.pushViewController(LoginViewController(), animated: false)
                        } else {
                            self.activityIndicator.stopLoading()
                            self.errorTF.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    @IBAction private func Connect(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func nameTFClicked(_ sender: Any) {
        activityIndicator.stopLoading()
        errorTF.isHidden = true
        nullErrorTF.isHidden = true
    }
    
    @IBAction private func mailTFClicked(_ sender: Any) {
        activityIndicator.stopLoading()
        errorTF.isHidden = true
        nullErrorTF.isHidden = true
    }
    
    @IBAction private func pwdTFClicked(_ sender: Any) {
        assoPasswordTF.text = ""
        activityIndicator.stopLoading()
        errorTF.isHidden = true
        nullErrorTF.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            assoLogo.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesNames!.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesNames![row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assoCategoryTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case assoNameTF:
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoEmailTF:
            let maxLength = 75
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoPasswordTF:
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case assoCategoryTF:
            return false
        default:
            return true
        }
    }
}

