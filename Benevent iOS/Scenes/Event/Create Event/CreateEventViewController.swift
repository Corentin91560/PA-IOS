//
//  CreateEventViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
    let eventWS: EventWebService = EventWebService()
    let postWS: PostWebService = PostWebService()
    
    var categories : [Category]!
    var connectedAsso: Association?
    var generalEvent: Event?
    
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var eventNameTF: UITextField!
    @IBOutlet var eventDescriptionTF: UITextView!
    @IBOutlet var eventStartDateTF: UITextField!
    @IBOutlet var eventEndDateTF: UITextField!
    @IBOutlet var eventLocationTF: UITextField!
    @IBOutlet var eventMaxBenevoleTF: UITextField!
    @IBOutlet var categoryTF: UITextField!
    @IBOutlet var ValidButton: UIButton!
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var categoriesNames: [String]? = nil
    var selectedCategory: Category!
    var startDatePicker: UIDatePicker?
    var endDatePicker: UIDatePicker?
    var categoryPicker: UIPickerView!
    
    
    static func newInstance(categories: [Category], connectedAsso: Association?, generalEvent: Event) -> CreateEventViewController {
        let CreateEventVC: CreateEventViewController = CreateEventViewController()
        CreateEventVC.categories = categories
        CreateEventVC.connectedAsso = connectedAsso
        CreateEventVC.generalEvent = generalEvent
        return CreateEventVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        assoLogo.load(url: URL(string: (connectedAsso?.logo)!)!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        ValidButton.layer.cornerRadius = ValidButton.bounds.size.height/2
        activityIndicator.isHidden = true
        eventMaxBenevoleTF.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupPickers()
    }
    
    func setupPickers() {
        // CATEGORY PICKER
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoriesNames = categories.map{ $0.name }
        categoryTF.inputView = categoryPicker
        categoryTF.text = self.categoriesNames?[1]
        selectedCategory = categories[1]
        
        // DATE PICKERS
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        eventStartDateTF.text = formatter.string(from: Date())
        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        startDatePicker?.locale = Locale(identifier: "fr_FR")
        endDatePicker?.locale = Locale(identifier: "fr_FR")
        startDatePicker?.addTarget(self, action: #selector(startdateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.addTarget(self, action: #selector(enddateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.minimumDate = Date()
        eventStartDateTF.inputView = startDatePicker
        eventEndDateTF.inputView = endDatePicker
    }
    
    @objc func startdateChanger(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        eventStartDateTF.text = formatter.string(from: datePicker.date)
    }
    
    
    @objc func enddateChanger(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        eventEndDateTF.text = formatter.string(from: datePicker.date)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func setupNavigationBar() {
        // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Créer un événement"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func Back() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func Valid(_ sender: Any) {
        var checkCallback = false
        activityIndicator.startLoading()
        let dateFormatter = DateFormatter() //TODO regler soucis heure -2 +2
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let startDateString = eventStartDateTF.text!
        let endDateString = eventEndDateTF.text!
        let startDate = dateFormatter.date(from: startDateString)!
        let endDate = dateFormatter.date(from: endDateString)!
        print("Start Date \(startDate)")
        print("End Date \(endDate)")
        
        if(startDate > endDate) {
            errorTF.isHidden = false
        } else {
            let eventToCreate = Event(name: eventNameTF.text!, apercu: eventDescriptionTF.text!, startDate: startDate, endDate: endDate, location: eventLocationTF.text!, maxBenevole: Int(eventMaxBenevoleTF.text!)!)
            eventToCreate.idAssociation = connectedAsso?.idAssociation!
            eventToCreate.idCategory = selectedCategory.idCategory!
            
            eventWS.newEvent(event: eventToCreate) { (sucess) in
                if(sucess || checkCallback) {
                    if(!checkCallback) {
                        let postToCreate = Post(message: "Un nouvel événement est organisé: \(eventToCreate.name) \n Il se déroulera du \(startDateString) au \(endDateString) \n Nous aurons besoin de \(eventToCreate.maxBenevole) bénévoles, inscrivez vous sur Benevent", date: Date())
                        postToCreate.idEvent = self.generalEvent?.idEvent
                        postToCreate.idAssociation = self.connectedAsso?.idAssociation
                        self.postWS.newPost(post: postToCreate) { (_) in }
                    }
                    self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.idAssociation!)!) { (eventsList) in
                        checkCallback = true
                        let EventVC = EventViewController.newInstance(events: eventsList, connectedAsso: self.connectedAsso!)
                        self.navigationController?.pushViewController(EventVC, animated: false)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopLoading()
                        self.errorTF.isHidden = false
                    }
                }
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
    }
      
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesNames!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesNames![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        self.view.endEditing(true)
    }
    
}
