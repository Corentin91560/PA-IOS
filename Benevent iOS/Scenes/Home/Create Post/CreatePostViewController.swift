//
//  CreatePostViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 02/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    private let postWS : PostWebService = PostWebService()
    private let eventWS : EventWebService = EventWebService()
    private let userWS: UserWebService = UserWebService()
      
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var eventTF: UITextField!
    @IBOutlet var postMessageText: UITextView!
    @IBOutlet var validButton: UIButton!
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var isPublicPost: UISwitch!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var connectedAssociation: Association!
    private var eventList: [Event]!
    private var generalEvent: Event!
    
    private var eventPicker: UIPickerView!
    private var eventNamesList: [String]? = nil
    private var selectedEvent: Event!
    
    class func newInstance(events: [Event]) -> CreatePostViewController {
        let newPostVC = CreatePostViewController()
        newPostVC.generalEvent = events.filter({ $0.getFakeEvent() })[0]
        newPostVC.eventList = events.filter({ !$0.getFakeEvent() })
        newPostVC.connectedAssociation = AppConfig.connectedAssociation
        return newPostVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        assoLogo.load(url: URL(string: connectedAssociation.getLogo())!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        activityIndicator.isHidden = true
        setupNavigationBar()
        setupPicker()
        validButton.layer.cornerRadius = validButton.bounds.size.height/2
        eventTF.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    private func setupPicker() {
        eventNamesList = eventList.map{ $0.getName() }
        if(eventList.count > 0) {
            eventPicker = UIPickerView()
            eventPicker.dataSource = self
            eventPicker.delegate = self
            isPublicPost.isOn = false
            eventTF.inputView = eventPicker
            eventTF.text = self.eventNamesList?[0]
            selectedEvent = eventList[0]
        } else {
            eventTF.isEnabled = false
            isPublicPost.isOn = true
            isPublicPost.isUserInteractionEnabled = false
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Nouveau post"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @IBAction private func switchPublicClicked(_ sender: Any) {
        if(isPublicPost.isOn) {
            eventTF.isEnabled = false
            eventTF.text = ""
        } else {
            eventTF.isEnabled = true
            eventTF.text = self.eventNamesList?[0]
        }
    }
    
    @IBAction private func eventTFClicked(_ sender: Any) {
        errorTF.isHidden = true
    }
    
    @IBAction private func Validate(_ sender: Any) {
        if(postMessageText.text! != "") {
            var checkCallback = false
            activityIndicator.startLoading()
            if(self.isPublicPost.isOn) {
                self.selectedEvent = generalEvent
            }
            let postToCreate = Post(message: postMessageText.text, date: Date())
            postToCreate.setIdEvent(idEvent: selectedEvent.getIdEvent())
            postToCreate.setIdAssociation(idAssociation: connectedAssociation.getIdAssociation())
            postWS.newPost(post: postToCreate) { (sucess) in
                if (sucess || checkCallback) {
                    checkCallback = true
                    self.postWS.getPosts(idAsso: self.connectedAssociation.getIdAssociation()) { (posts) in
                        self.eventWS.getEventsByAssociation(idAsso: self.connectedAssociation.getIdAssociation()) { (events) in
                            self.userWS.getUsersByIdAsso(idAsso: self.connectedAssociation.getIdAssociation()) { (users) in
                                self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, events: events, users: users), animated: false)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopLoading()
                        self.errorTF.isHidden = false
                    }
                }
            }
        } else {
            errorTF.text = "Les champs sont obligatoires"
            errorTF.isHidden = false
        }
    }
    
    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventNamesList!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventNamesList![row] == "" ? "Aucun" : eventNamesList![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventTF.text = eventNamesList![row] == "" ? "Aucun" : eventNamesList![row]
        selectedEvent = eventList[row]
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == eventTF) {
            return false
        }
           return true
    }
}
