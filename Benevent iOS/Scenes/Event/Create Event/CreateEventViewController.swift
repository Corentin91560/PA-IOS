//
//  CreateEventViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
    private let eventWS: EventWebService = EventWebService()
    private let postWS: PostWebService = PostWebService()
    
    private var categories : [Category]!
    private var connectedAsso: Association!
    private var generalEvent: Event!
    
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
    
    private var categoriesNames: [String]? = nil
    private var selectedCategory: Category!
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    private var categoryPicker: UIPickerView!
    
    static func newInstance(categories: [Category], generalEvent: Event) -> CreateEventViewController {
        let createEventVC: CreateEventViewController = CreateEventViewController()
        createEventVC.categories = categories
        createEventVC.connectedAsso = AppConfig.connectedAssociation
        createEventVC.generalEvent = generalEvent
        return createEventVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        assoLogo.load(url: URL(string: connectedAsso.getLogo())!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        ValidButton.layer.cornerRadius = ValidButton.bounds.size.height/2
        activityIndicator.isHidden = true
        eventMaxBenevoleTF.delegate = self
        eventStartDateTF.delegate = self
        eventEndDateTF.delegate = self
        categoryTF.delegate = self
        eventStartDateTF.text = formatter.string(from: Date())
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupPickers()
    }
    
    private func setupPickers() {
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoriesNames = categories.map{ $0.getName() }
        categoryTF.inputView = categoryPicker
        categoryTF.text = self.categoriesNames?[0]
        selectedCategory = categories[0]
        
        startDatePicker = UIDatePicker()
        startDatePicker?.locale = Locale(identifier: "fr_FR")
        startDatePicker?.addTarget(self, action: #selector(startdateChanger(datePicker:)), for: .valueChanged)
        eventStartDateTF.inputView = startDatePicker
        
        endDatePicker = UIDatePicker()
        endDatePicker?.locale = Locale(identifier: "fr_FR")
        endDatePicker?.addTarget(self, action: #selector(enddateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.minimumDate = Date()
        eventEndDateTF.inputView = endDatePicker
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Créer un événement"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc private func startdateChanger(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        endDatePicker?.minimumDate = datePicker.date
        eventStartDateTF.text = formatter.string(from: datePicker.date)
        if(endDatePicker!.date < datePicker.date) {
            endDatePicker?.date = datePicker.date
            eventEndDateTF.text = formatter.string(from: datePicker.date)
        }
    }
    
    @objc private func enddateChanger(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        eventEndDateTF.text = formatter.string(from: datePicker.date)
    }
    
    
    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction private func Valid(_ sender: Any) {
        var checkCallback = false
        activityIndicator.startLoading()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let startDateString = eventStartDateTF.text!
        let endDateString = eventEndDateTF.text!
        let startDate = dateFormatter.date(from: startDateString)!
        let endDate = dateFormatter.date(from: endDateString)!
        endDatePicker?.minimumDate = startDatePicker?.date
      
        let eventToCreate = Event(name: eventNameTF.text!, apercu: eventDescriptionTF.text!, startDate: startDate, endDate: endDate, location: eventLocationTF.text!, maxBenevole: Int(eventMaxBenevoleTF.text!)!, fakeEvent: false)
        eventToCreate.setIdAssociation(idAssociation: connectedAsso.getIdAssociation())
        eventToCreate.setIdCategory(idCategory: selectedCategory.getIdCategory())
        
        eventWS.newEvent(event: eventToCreate) { (sucess) in
            if(sucess || checkCallback) {
                if(!checkCallback) {
                    let postToCreate = Post(message: "Un nouvel événement est organisé: \(eventToCreate.getName()) \n Il se déroulera du \(startDateString) au \(endDateString) \n Nous aurons besoin de \(eventToCreate.getMaxBenevole()) bénévoles, inscrivez vous sur Benevent", date: Date())
                    postToCreate.setIdEvent(idEvent: self.generalEvent.getIdEvent())
                    postToCreate.setIdAssociation(idAssociation: self.connectedAsso.getIdAssociation())
                    self.postWS.newPost(post: postToCreate) { (_) in }
                }
                checkCallback = true
                self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.getIdAssociation())!) { (eventsList) in
                    let EventVC = EventViewController.newInstance(events: eventsList)
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
       
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == eventStartDateTF || textField == eventEndDateTF || textField == categoryTF) {
            let allowedCharacters = CharacterSet(charactersIn:"")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else if (textField == eventMaxBenevoleTF) {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
