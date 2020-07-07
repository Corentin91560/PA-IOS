//
//  EventDetailViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
 
class EventDetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var personsButton: UIButton!
    @IBOutlet var QRButton: UIButton!
    @IBOutlet var validButton: UIButton!
    @IBOutlet var eventNameTF: UITextField!
    @IBOutlet var eventDescriptionTF: UITextView!
    @IBOutlet var eventCategoryTF: UITextField!
    @IBOutlet var eventStartDateTF: UITextField!
    @IBOutlet var eventEndDateTF: UITextField!
    @IBOutlet var eventMaxBenevoleTF: UITextField!
    @IBOutlet var eventLocationTF: UITextField!
    
    let categoryWS: CategoryWebService = CategoryWebService()
    let eventWS: EventWebService = EventWebService()
    
    var connectedAsso: Association?
    var event: Event?
    var categories: [Category]!
    var selectedCategory: Category?
    var startDatePicker: UIDatePicker?
    var endDatePicker: UIDatePicker?
    var categoryPicker: UIPickerView!
    var categoriesNames: [String]!
    
    class func newInstance(connectedAsso: Association, event: Event, categories: [Category]) -> EventDetailViewController {
        let EventDetailVC: EventDetailViewController = EventDetailViewController()
        EventDetailVC.connectedAsso = connectedAsso
        EventDetailVC.event = event
        EventDetailVC.categories = categories
        return EventDetailVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        if(event!.isInProgress(startDate: event!.startDate, endDate: event!.endDate)) {
            self.personsButton.layer.cornerRadius = personsButton.bounds.size.height/3
            self.QRButton.layer.cornerRadius = QRButton.bounds.size.height/3
        } else {
            self.personsButton.isHidden = true
            self.QRButton.isHidden = true
        }
        self.validButton.layer.cornerRadius = validButton.bounds.size.height/2
        self.eventMaxBenevoleTF.delegate = self
        setupNavigationBar()
        setupTextFields()
        setupPickers()
    }
    
    func setupPickers() {
        // CATEGORY PICKER
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoriesNames = categories.map{ $0.name }
        eventCategoryTF.inputView = categoryPicker
        eventCategoryTF.text = categoriesNames[(event?.idcat)!]
        selectedCategory = categories[(event?.idcat)!]
        
        // DATE PICKERS
        self.startDatePicker = UIDatePicker()
        self.endDatePicker = UIDatePicker()
        startDatePicker?.locale = Locale(identifier: "fr")
        endDatePicker?.locale = Locale(identifier: "fr")
        startDatePicker?.addTarget(self, action: #selector(startdateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.addTarget(self, action: #selector(enddateChanger(datePicker:)), for: .valueChanged)
        self.eventStartDateTF.inputView = startDatePicker
        self.eventEndDateTF.inputView = endDatePicker
    }
    
    func setupTextFields() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy HH:mm"
        
        self.eventNameTF.text = event?.name
        self.eventDescriptionTF.text = event?.apercu
        self.eventCategoryTF.text = selectedCategory?.name
        self.eventStartDateTF.text = formatterDate.string(from: event!.startDate)
        self.eventEndDateTF.text = formatterDate.string(from: event!.endDate)
        self.eventLocationTF.text = event?.location
        self.eventMaxBenevoleTF.text = String(event!.maxBenevole)
    }
    
    func setupNavigationBar() {
       // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "\(event!.name)"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "x.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        // Right Item Config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                  image: UIImage(systemName: "pencil"),
                  style: .plain,
                  target: self,
                  action: #selector(Edit))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func Back() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func Edit() {
        eventNameTF.isEnabled = !eventNameTF.isEnabled
        eventDescriptionTF.isEditable = !eventDescriptionTF.isEditable
        eventCategoryTF.isEnabled = !eventCategoryTF.isEnabled
        eventStartDateTF.isEnabled = !eventStartDateTF.isEnabled
        eventEndDateTF.isEnabled = !eventEndDateTF.isEnabled
        eventLocationTF.isEnabled = !eventLocationTF.isEnabled
        eventMaxBenevoleTF.isEnabled = !eventMaxBenevoleTF.isEnabled
    }
    
    @objc func startdateChanger(datePicker : UIDatePicker) {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MM/yyyy HH:mm"
         self.eventStartDateTF.text = formatter.string(from: datePicker.date)
     }
     
     
     @objc func enddateChanger(datePicker : UIDatePicker) {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MM/yyyy HH:mm"
         self.eventEndDateTF.text = formatter.string(from: datePicker.date)
     }
    
    @IBAction func Participants(_ sender: Any) {
        
    }
    
    @IBAction func showQR(_ sender: Any) {
        self.navigationController?.pushViewController(EventQRViewController.newInstance(event: self.event!), animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
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
        self.eventCategoryTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        self.view.endEditing(true)
    }
}
