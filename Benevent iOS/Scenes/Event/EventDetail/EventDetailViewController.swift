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
    @IBOutlet var participantsButton: UIButton!
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
    @IBOutlet var deleteEventButton: UIButton!
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
        EventDetailVC.selectedCategory = categories.filter{ $0.idCategory! == event.idCategory! }[0]
        return EventDetailVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        assoLogo.load(url: URL(string: (connectedAsso?.logo)!)!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        assoLogo.layer.cornerRadius = 25
        activityIndicator.isHidden = true
        deleteEventButton.isHidden = true
        self.hideKeyboardWhenTappedAround()
        eventDescriptionTF.delegate = self
        eventStartDateTF.delegate = self
        eventEndDateTF.delegate = self
        eventCategoryTF.delegate = self
        if(event!.isInProgress(startDate: event!.startDate, endDate: event!.endDate)) {
            self.participantsButton.layer.cornerRadius = participantsButton.bounds.size.height/3 //TODO inverser le fonctionnement (cacher de base)
            self.QRButton.layer.cornerRadius = QRButton.bounds.size.height/3
        } else {
            self.participantsButton.isHidden = true
            self.QRButton.isHidden = true
        }
        validButton.layer.cornerRadius = validButton.bounds.size.height/2
        eventMaxBenevoleTF.delegate = self
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
        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        startDatePicker?.addTarget(self, action: #selector(startdateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.addTarget(self, action: #selector(enddateChanger(datePicker:)), for: .valueChanged)
        startDatePicker?.locale = Locale(identifier: "fr_FR")
        endDatePicker?.locale = Locale(identifier: "fr_FR")
        eventStartDateTF.inputView = startDatePicker
        eventEndDateTF.inputView = endDatePicker
    }
    
    func setupTextFields() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy HH:mm"
        formatterDate.timeZone = TimeZone(abbreviation: "UTC")
        
        eventNameTF.text = event?.name
        eventDescriptionTF.text = event?.apercu
        eventCategoryTF.text = selectedCategory?.name
        eventStartDateTF.text = formatterDate.string(from: event!.startDate)
        eventEndDateTF.text = formatterDate.string(from: event!.endDate)
        eventLocationTF.text = event?.location
        eventMaxBenevoleTF.text = String(event!.maxBenevole)
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
        eventNameTF.isEnabled = !self.eventNameTF.isEnabled
        eventDescriptionTF.isEditable = !self.eventDescriptionTF.isEditable
        eventCategoryTF.isEnabled = !self.eventCategoryTF.isEnabled
        eventStartDateTF.isEnabled = !self.eventStartDateTF.isEnabled
        eventEndDateTF.isEnabled = !self.eventEndDateTF.isEnabled
        eventLocationTF.isEnabled = !self.eventLocationTF.isEnabled
        eventMaxBenevoleTF.isEnabled = !self.eventMaxBenevoleTF.isEnabled
        deleteEventButton.isHidden = !self.deleteEventButton.isHidden
    }
    
    @objc func startdateChanger(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        endDatePicker?.minimumDate = datePicker.date
        eventStartDateTF.text = formatter.string(from: datePicker.date)
        if(endDatePicker!.date < datePicker.date) {
            endDatePicker?.date = datePicker.date
            eventEndDateTF.text = formatter.string(from: datePicker.date)
        }
     }
     
     
     @objc func enddateChanger(datePicker : UIDatePicker) {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MM/yyyy HH:mm"
         eventEndDateTF.text = formatter.string(from: datePicker.date)
     }
    
    @IBAction func Participants(_ sender: Any) {
        activityIndicator.startLoading()
        userWS.getUsersByIdEvent(idEvent: (self.event?.idEvent)!) { (participants) in
            self.navigationController?.pushViewController(EventParticipantsViewController.newInstance(participants: participants), animated: true)
        }
        activityIndicator.stopLoading()
    }
    
    @IBAction func showQR(_ sender: Any) {
        activityIndicator.startLoading()
        self.navigationController?.pushViewController(EventQRViewController.newInstance(event: self.event!), animated: true)
        activityIndicator.stopLoading()
    }
    
    @IBAction func Valid(_ sender: Any) {
        activityIndicator.startLoading()
        var checkCallback = false
        let newEvent = Event(name: eventNameTF.text!, apercu: eventDescriptionTF.text!, startDate: dateConverter(dateMySQL: eventStartDateTF.text!)! , endDate: dateConverter(dateMySQL: eventEndDateTF.text!)!, location: eventLocationTF.text!, maxBenevole: Int(eventMaxBenevoleTF.text!)!)
        newEvent.idAssociation = connectedAsso?.idAssociation!
        newEvent.idEvent = self.event?.idEvent!
        newEvent.idCategory = selectedCategory?.idCategory
        
        eventWS.updateEvent(event: newEvent) { (sucess) in
            if (sucess || checkCallback) {
                checkCallback = true
                self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.idAssociation!)!) { (events) in
                    self.navigationController?.pushViewController(EventViewController.newInstance(events: events, connectedAsso: self.connectedAsso!), animated: false)
                }
            } else {
                DispatchQueue.main.sync {
                    self.activityIndicator.stopLoading()
                    self.errorTF.isHidden = false
                }
            }
        }
    }
    
    @IBAction func Delete(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Suppression", message: "Etes vous sur de vouloir supprimer l'événement \(self.event!.name) ?", preferredStyle: UIAlertController.Style.alert)

              deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
                  self.deleteEvent()
              }))
              
              deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
                  deleteAlert.dismiss(animated: true) {}
              }))
              present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteEvent() {
        var checkCallback = false
        self.activityIndicator.startLoading()
        self.eventWS.deleteEvent(idEvent: self.event!.idEvent!) { (sucess) in
            if (sucess || checkCallback) {
               self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.idAssociation!)!) { (events) in
                   checkCallback = true
                   self.navigationController?.pushViewController(EventViewController.newInstance(events: events, connectedAsso: self.connectedAsso!), animated: false)
               }
            } else {
                self.activityIndicator.stopLoading()
                self.errorTF.text = "Suppression impossible !"
                self.errorTF.isHidden = false
            }
        }
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
       {
           if (textField == eventStartDateTF || textField == eventEndDateTF || textField == eventCategoryTF) {
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
