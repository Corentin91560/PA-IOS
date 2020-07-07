//
//  SignupViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var assoNameTF: UITextField!
    @IBOutlet var assoEmailTF: UITextField!
    @IBOutlet var assoPwdTF: UITextField!
    @IBOutlet var assoCatTF: UITextField!
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var nullErrorTF: UILabel!
    
    let assoWS: AssociationWebService = AssociationWebService()
    
    var categories: [Category]!
    var categoriesNames: [String]? = nil
    var selectedCategory: Category!
    var categoryPicker: UIPickerView!
    
    class func newInstance(categories: [Category]) -> SignupViewController {
        let SignUpVC: SignupViewController = SignupViewController()
        SignUpVC.categories = categories
        return SignUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardWhenTappedAround()
        setupPicker()
        errorTF.isHidden = true
        signupButton.layer.cornerRadius = signupButton.bounds.height/2
    }
    
    func setupPicker() {
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoriesNames = categories.map{ $0.name }
        assoCatTF.inputView = categoryPicker
        assoCatTF.text = self.categoriesNames?[0]
        selectedCategory = categories[0]
    }
    
    @IBAction func Confirm(_ sender: Any) {
        if (self.assoNameTF.text == "" || self.assoEmailTF.text == "" || self.assoPwdTF.text == "") {
            self.nullErrorTF.isHidden = false
        } else {
            self.assoWS.Signup(name: assoNameTF.text!, email: assoEmailTF.text!, password: assoPwdTF.text!, idCategory: selectedCategory.idcat! ) { (sucess) in
                DispatchQueue.main.async {
                    if(sucess) {
                        self.navigationController?.pushViewController(LoginViewController(), animated: false)
                    } else {
                        self.errorTF.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func Connect(_ sender: Any) { self.navigationController?.popViewController(animated: true) }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  categoriesNames!.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesNames![row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assoCatTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        self.view.endEditing(true)
    }
    
    @IBAction func nameTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
    
    @IBAction func mailTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
    
    @IBAction func pwdTFClicked(_ sender: Any) {
        self.errorTF.isHidden = true
        self.nullErrorTF.isHidden = true
    }
}
