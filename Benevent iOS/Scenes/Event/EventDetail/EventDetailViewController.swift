//
//  EventDetailViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
 
class EventDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var assoLogo: UIImageView!
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
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let categoryWS: CategoryWebService = CategoryWebService()
    let eventWS: EventWebService = EventWebService()
    let userWS : UserWebService = UserWebService()
    
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
        EventDetailVC.selectedCategory = categories.filter{ $0.idcat! == event.idcat! }[0]
        return EventDetailVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        self.assoLogo.load(url: URL(string: (connectedAsso?.logo)!)!)
        self.assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        self.activityIndicator.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.eventDescriptionTF.delegate = self
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
        eventCategoryTF.text = selectedCategory?.name
        
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
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        // Right Item Config
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                  image: UIImage(named: "SF_pencil_tip_crop_circle_badge_plus"),
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
        self.activityIndicator.startLoading()
        self.userWS.getUserByIdEvent(idEvent: (self.event?.idev)!) { (participants) in
            self.navigationController?.pushViewController(EventParticipantsViewController.newInstance(participants: participants), animated: true)
        }
        self.activityIndicator.stopLoading()
    }
    
    @IBAction func showQR(_ sender: Any) {
        self.activityIndicator.startLoading()
        self.navigationController?.pushViewController(EventQRViewController.newInstance(event: self.event!), animated: true)
        self.activityIndicator.stopLoading()
    }
    
    @IBAction func Valid(_ sender: Any) {
        self.activityIndicator.startLoading()
        let newEvent = Event(name: eventNameTF.text!, apercu: eventDescriptionTF.text!, startDate: dateConverter(dateMySQL: eventStartDateTF.text!)! , endDate: dateConverter(dateMySQL: eventEndDateTF.text!)!, location: eventLocationTF.text!, maxBenevole: Int(eventMaxBenevoleTF.text!)!)
        newEvent.idas = connectedAsso?.idas!
        newEvent.idev = self.event?.idev!
        newEvent.idcat = selectedCategory?.idcat
        
        self.eventWS.updateEvent(event: newEvent) { (sucess) in
            if (sucess) {
                self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.idas!)!) { (events) in
                    self.navigationController?.pushViewController(EventViewController.newInstance(events: events, connectedAsso: self.connectedAsso!), animated: false)
                }
            }
        }
        //TODO : errorTextField always appears because of the callback
        self.activityIndicator.stopLoading()
        self.errorTF.isHidden = false
                
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
    
    @IBAction func eventNameClicked(_ sender: Any) {
        self.eventNameTF.text = ""
        self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTF.isHidden = true
        self.validButton.isEnabled = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.eventDescriptionTF.text = ""
        self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTF.isHidden = true
        self.validButton.isEnabled = true
    }
    
    @IBAction func eventCategoryClicked(_ sender: Any) {
        self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTF.isHidden = true
        self.validButton.isEnabled = true
    }
    
    @IBAction func eventStartDateClicked(_ sender: Any) {
        self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTF.isHidden = true
        self.validButton.isEnabled = true
    }
    
    @IBAction func eventEndDateClicked(_ sender: Any) {
        self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        self.errorTF.isHidden = true
        self.validButton.isEnabled = true
    }
    
       @IBAction func eventLocationClicked(_ sender: Any) {
         self.eventLocationTF.text = ""
         self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
         self.errorTF.isHidden = true
         self.validButton.isEnabled = true
     }
     
     @IBAction func eventMaxBenevoleClicked(_ sender: Any) {
         self.eventMaxBenevoleTF.text = ""
         self.validButton.backgroundColor = UIColor(named: "BackgroundGreen")
         self.errorTF.isHidden = true
         self.validButton.isEnabled = true
     }
    
    func dateConverter(dateMySQL: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.date(from: dateMySQL) as Date?
    }
}
