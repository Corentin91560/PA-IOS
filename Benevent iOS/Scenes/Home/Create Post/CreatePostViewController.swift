//
//  CreatePostViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 02/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var assoLogo: UIImageView!
    @IBOutlet var eventTF: UITextField!
    @IBOutlet var postMessageText: UITextView!
    @IBOutlet var validButton: UIButton!
    @IBOutlet var errorTF: UILabel!
    @IBOutlet var isPublicPost: UISwitch!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let postWS : PostWebService = PostWebService()
    let eventWS : EventWebService = EventWebService()
    let userWS: UserWebService = UserWebService()
    
    var connectedAsso: Association? = nil
    var eventList: [Event]!
    var eventPicker: UIPickerView!
    var eventNamesList: [String]? = nil
    var generalEvent: Event!
    var selectedEvent: Event!
    
    class func newInstance(events: [Event], connectedAsso: Association?) -> CreatePostViewController {
        let newPostVC = CreatePostViewController()
        newPostVC.generalEvent = events.filter({ $0.fakeEvent! })[0]
        newPostVC.eventList = events.filter({ !$0.fakeEvent! })
        newPostVC.connectedAsso = connectedAsso
        return newPostVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        assoLogo.load(url: URL(string: (connectedAsso?.logo)!)!)
        assoLogo.frame = CGRect(x: self.view.frame.width/2 - 150, y: 50 + (self.navigationController?.navigationBar.frame.height)!, width: 300, height: 300)
        activityIndicator.isHidden = true
        setupNavigationBar()
        setupPicker()
        validButton.layer.cornerRadius = validButton.bounds.size.height/2
        eventTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupPicker() {
        eventNamesList = eventList.map{ $0.name }
        if(eventList.count > 0) {
            self.isPublicPost.isOn = false
            self.eventPicker = UIPickerView()
            self.eventPicker.dataSource = self
            self.eventPicker.delegate = self
            self.eventTF.inputView = eventPicker
            self.eventTF.text = self.eventNamesList?[0]
            self.selectedEvent = eventList[0]
        } else {
            self.eventTF.isEnabled = false
            self.isPublicPost.isOn = true
            self.isPublicPost.isUserInteractionEnabled = false
        }
    }
    
    func setupNavigationBar() {
        // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Nouveau post"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @IBAction func switchPublicClicked(_ sender: Any) {
        if(self.isPublicPost.isOn) {
            self.eventTF.isEnabled = false
            self.eventTF.text = ""
        } else {
            self.eventTF.isEnabled = true
            self.eventTF.text = self.eventNamesList?[0]
        }
    }
    
    @IBAction func Validate(_ sender: Any) {
        if(postMessageText.text! != "") {
            var checkCallback = false
            self.activityIndicator.startLoading()
            if(self.isPublicPost.isOn) {
                self.selectedEvent = generalEvent
            }
            let postToCreate = Post(message: postMessageText.text, date: Date())
            postToCreate.idEvent = selectedEvent.idEvent
            postToCreate.idAssociation = connectedAsso?.idAssociation
            self.postWS.newPost(post: postToCreate) { (sucess) in
                if (sucess || checkCallback) {
                    self.postWS.getPosts(idAsso: (self.connectedAsso?.idAssociation)!) { (posts) in
                        self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso!.idAssociation!) { (events) in
                            self.userWS.getUsersByIdAsso(idAsso: self.connectedAsso!.idAssociation!) { (users) in
                                checkCallback = true
                                self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, connectedAsso: self.connectedAsso, events: events, users: users), animated: false)
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
    
    @objc func Back() {
        self.navigationController?.popViewController(animated: false)
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
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == eventTF {
               let allowedCharacters = CharacterSet(charactersIn:"")//Here change this characters based on your requirement
               let characterSet = CharacterSet(charactersIn: string)
               return allowedCharacters.isSuperset(of: characterSet)
           }
           return true
    }
    
    @IBAction func eventTFClicked(_ sender: Any) {
        errorTF.isHidden = true
    }
    
}
