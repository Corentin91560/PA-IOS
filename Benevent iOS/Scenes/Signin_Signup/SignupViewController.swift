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
    @IBOutlet var validButton: UIButton!
    @IBOutlet var connectButton: UIButton!
    //TODO: Remplacer les categories en dure par le call API
    
    let categoriesAsso = [ "Animalière",
                           "Culturelle",
                          "Environnementale",
                          "Humanitaire",
                          "Musicale",
                          "Sportive",
                          ]
    var idCategorie = 0
    let pickerView = UIPickerView()
    let assoWS: AssociationWebService = AssociationWebService()
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround() 
        assoCatTF.inputView = pickerView
        pickerView.delegate = self
        errorTF.isHidden = true
        validButton.layer.cornerRadius = validButton.bounds.height/2
        super.viewDidLoad()
    }
    
    @IBAction func Confirm(_ sender: Any) {
        let email = assoEmailTF.text!
        let pwd = assoPwdTF.text!
        let name = assoNameTF.text!
        
        self.assoWS.Signup(name: name, email: email, password: pwd, idCategory: idCategorie ) { (sucess) in
            DispatchQueue.main.async {
                if(sucess) {
                    let Login = LoginViewController()
                    self.navigationController?.pushViewController(Login, animated: false)
                } else {
                    self.errorTF.isHidden = false
                }
            }
        }
    }
    
    @IBAction func Connect(_ sender: Any) {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: false)
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  categoriesAsso.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesAsso[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assoCatTF.text = categoriesAsso[row]
        idCategorie = row + 1
    }
    
    @IBAction func nameTFClicked(_ sender: Any) {self.errorTF.isHidden = true}
    @IBAction func mailTFClicked(_ sender: Any) {self.errorTF.isHidden = true}
    @IBAction func pwdTFClicked(_ sender: Any) {self.errorTF.isHidden = true}
    //TODO: Gerer le nullable
    
    
}
