//
//  EventDetailViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
 
class EventDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    private let categoryWS: CategoryWebService = CategoryWebService()
    private let eventWS: EventWebService = EventWebService()
    private let userWS : UserWebService = UserWebService()
    
    private var connectedAsso: Association!
    private var event: Event!
    private var categories: [Category]!
    private var selectedCategory: Category!
    
    @IBOutlet private var assoLogo: UIImageView!
    @IBOutlet private var participantsButton: UIButton!
    @IBOutlet private var QRButton: UIButton!
    @IBOutlet private var validButton: UIButton!
    @IBOutlet private var eventNameTF: UITextField!
    @IBOutlet private var eventDescriptionTF: UITextView!
    @IBOutlet private var eventCategoryTF: UITextField!
    @IBOutlet private var eventStartDateTF: UITextField!
    @IBOutlet private var eventEndDateTF: UITextField!
    @IBOutlet private var eventMaxBenevoleTF: UITextField!
    @IBOutlet private var eventLocationTF: UITextField!
    @IBOutlet private var errorTF: UILabel!
    @IBOutlet private var deleteEventButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    private var categoryPicker: UIPickerView!
    private var categoriesNames: [String]!
    
    class func newInstance(event: Event, categories: [Category]) -> EventDetailViewController {
        let eventDetailsVC: EventDetailViewController = EventDetailViewController()
        eventDetailsVC.connectedAsso = AppConfig.connectedAssociation
        eventDetailsVC.event = event
        eventDetailsVC.categories = categories
        eventDetailsVC.selectedCategory = categories.filter{ $0.getIdCategory() == event.getIdCategory() }[0]
        return eventDetailsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        assoLogo.load(url: URL(string: connectedAsso.getLogo())!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        assoLogo.layer.cornerRadius = 25
        activityIndicator.isHidden = true
        deleteEventButton.isHidden = true
        hideKeyboardWhenTappedAround()
        if(event!.isInProgress()) {
            participantsButton.layer.cornerRadius = participantsButton.bounds.size.height/3 //TODO inverser le fonctionnement (cacher de base)
            QRButton.layer.cornerRadius = QRButton.bounds.size.height/3
        } else {
            participantsButton.isHidden = true
            QRButton.isHidden = true
        }
        validButton.layer.cornerRadius = validButton.bounds.size.height/2
        setupNavigationBar()
        setupTextFields()
        setupPickers()
    }
    
    private func setupPickers() {
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoriesNames = categories.map{ $0.getName() }
        eventCategoryTF.inputView = categoryPicker
        eventCategoryTF.text = selectedCategory.getName()
        
        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        startDatePicker?.addTarget(self, action: #selector(startdateChanger(datePicker:)), for: .valueChanged)
        endDatePicker?.addTarget(self, action: #selector(enddateChanger(datePicker:)), for: .valueChanged)
        startDatePicker?.locale = Locale(identifier: "fr_FR")
        endDatePicker?.locale = Locale(identifier: "fr_FR")
        eventStartDateTF.inputView = startDatePicker
        eventEndDateTF.inputView = endDatePicker
    }
    
    private func setupTextFields() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy HH:mm"
        formatterDate.timeZone = TimeZone(abbreviation: "UTC")
        
        eventNameTF.delegate = self
        eventDescriptionTF.delegate = self
        eventStartDateTF.delegate = self
        eventEndDateTF.delegate = self
        eventCategoryTF.delegate = self
        eventLocationTF.delegate = self
        eventMaxBenevoleTF.delegate = self
        eventNameTF.text = event?.getName()
        eventDescriptionTF.text = event?.getApercu()
        eventCategoryTF.text = selectedCategory.getName()
        eventStartDateTF.text = formatterDate.string(from: event!.getStartDate())
        eventEndDateTF.text = formatterDate.string(from: event!.getEndDate())
        eventLocationTF.text = event?.getLocation()
        eventMaxBenevoleTF.text = String(event!.getMaxBenevole())
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "\(event!.getName())"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                  image: UIImage(named: "SF_pencil_tip_crop_circle_badge_plus"),
                  style: .plain,
                  target: self,
                  action: #selector(Edit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
    
    private func deleteEvent() {
        var checkCallback = false
        activityIndicator.startLoading()
        eventWS.deleteEvent(idEvent: self.event!.getIdEvent()) { (sucess) in
            if (sucess || checkCallback) {
               self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso.getIdAssociation()) { (events) in
                   checkCallback = true
                   self.navigationController?.pushViewController(EventViewController.newInstance(events: events), animated: false)
               }
            } else {
                self.activityIndicator.stopLoading()
                self.errorTF.text = "Suppression impossible !"
                self.errorTF.isHidden = false
            }
        }
    }
    
    private func dateConverter(dateMySQL: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.date(from: dateMySQL) as Date?
    }

    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func Edit() {
        eventNameTF.isEnabled = !self.eventNameTF.isEnabled
        eventDescriptionTF.isEditable = !self.eventDescriptionTF.isEditable
        eventCategoryTF.isEnabled = !self.eventCategoryTF.isEnabled
        eventStartDateTF.isEnabled = !self.eventStartDateTF.isEnabled
        eventEndDateTF.isEnabled = !self.eventEndDateTF.isEnabled
        eventLocationTF.isEnabled = !self.eventLocationTF.isEnabled
        eventMaxBenevoleTF.isEnabled = !self.eventMaxBenevoleTF.isEnabled
        deleteEventButton.isHidden = !self.deleteEventButton.isHidden
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
    
    @IBAction private func Participants(_ sender: Any) {
        activityIndicator.startLoading()
        userWS.getUsersByIdEvent(idEvent: self.event.getIdEvent()) { (participants) in
            self.navigationController?.pushViewController(EventParticipantsViewController.newInstance(participants: participants), animated: true)
        }
        activityIndicator.stopLoading()
    }
    
    @IBAction private func showQR(_ sender: Any) {
        activityIndicator.startLoading()
        navigationController?.pushViewController(EventQRViewController.newInstance(event: self.event!), animated: true)
        activityIndicator.stopLoading()
    }
    
    @IBAction private func Valid(_ sender: Any) {
        if (eventNameTF.text == "" ) {
            errorTF.text = "L'événement doit avoir un nom ! "
            errorTF.isHidden = false
        } else {
            activityIndicator.startLoading()
            var checkCallback = false
            let newEvent = Event(name: eventNameTF.text!, apercu: eventDescriptionTF.text!, startDate: dateConverter(dateMySQL: eventStartDateTF.text!)! , endDate: dateConverter(dateMySQL: eventEndDateTF.text!)!, location: eventLocationTF.text!, maxBenevole: Int(eventMaxBenevoleTF.text!)!, fakeEvent: false)
            newEvent.setIdAssociation(idAssociation: connectedAsso.getIdAssociation())
            newEvent.setIdEvent(idEvent: self.event.getIdEvent())
            newEvent.setIdCategory(idCategory: selectedCategory.getIdCategory())
            eventWS.updateEvent(event: newEvent) { (sucess) in
                if (sucess || checkCallback) {
                    checkCallback = true
                    self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso.getIdAssociation()) { (events) in
                        self.navigationController?.pushViewController(EventViewController.newInstance(events: events), animated: false)
                    }
                } else {
                    DispatchQueue.main.sync {
                        self.activityIndicator.stopLoading()
                        self.errorTF.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction private func Delete(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Suppression", message: "Etes vous sur de vouloir supprimer l'événement \(self.event!.getName()) ?", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { (action: UIAlertAction!) in
            self.deleteEvent()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true) {}
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction private func eventCategoryClicked(_ sender: Any) {
        validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTF.isHidden = true
        validButton.isEnabled = true
    }
    
    @IBAction private func eventStartDateClicked(_ sender: Any) {
       validButton.backgroundColor = UIColor(named: "BackgroundGreen")
       errorTF.isHidden = true
       validButton.isEnabled = true
    }
    
    @IBAction private func eventEndDateClicked(_ sender: Any) {
        validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTF.isHidden = true
        validButton.isEnabled = true
    }
    
    @IBAction private func eventLocationClicked(_ sender: Any) {
        validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTF.isHidden = true
        validButton.isEnabled = true
    }
     
    @IBAction private func eventMaxBenevoleClicked(_ sender: Any) {
        validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTF.isHidden = true
        validButton.isEnabled = true
    }
    
    @IBAction private func eventNameClicked(_ sender: Any) {
        validButton.backgroundColor = UIColor(named: "BackgroundGreen")
        errorTF.isHidden = true
        validButton.isEnabled = true
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
        eventCategoryTF.text = categoriesNames![row]
        selectedCategory = categories[row]
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       validButton.backgroundColor = UIColor(named: "BackgroundGreen")
       errorTF.isHidden = true
       validButton.isEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case eventNameTF:
            let maxLength = 40
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case eventCategoryTF:
            return false
        case eventStartDateTF:
           return false
        case eventEndDateTF:
            return false
        case eventLocationTF:
            let maxLength = 250
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case eventMaxBenevoleTF:
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return (allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength)
        default:
            return true
        }
    }
}
