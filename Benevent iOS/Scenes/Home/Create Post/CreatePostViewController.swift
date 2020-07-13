//
//  CreatePostViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 02/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var eventTextField: UITextField!
    @IBOutlet var postMessageText: UITextView!
    @IBOutlet var validButton: UIButton!
    @IBOutlet var errorTextField: UILabel!
    @IBOutlet var publicPost: UISwitch!
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
        self.activityIndicator.isHidden = true
        setupNavigationBar()
        setupPicker()
        publicPost.isOn = false
        validButton.layer.cornerRadius = validButton.bounds.size.height/2
        self.hideKeyboardWhenTappedAround() 
        super.viewDidLoad()
    }
    
    func setupPicker() {
        eventNamesList = eventList.map{ $0.name }
        eventPicker = UIPickerView()
        eventPicker.dataSource = self
        eventPicker.delegate = self
        eventTextField.inputView = eventPicker
        eventTextField.text = self.eventNamesList?[0]
        selectedEvent = eventList[0]
    }
    
    func setupNavigationBar() {
        // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Nouveau post"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "x.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @IBAction func swiftPublicClicked(_ sender: Any) {
        if(self.publicPost.isOn) {
            self.eventTextField.isEnabled = false
            self.eventTextField.text = ""
        } else {
            self.eventTextField.isEnabled = true
            self.eventTextField.text = self.eventNamesList?[0]
        }
    }
    
    @IBAction func Valid(_ sender: Any) {
        var checkCallback = false
        self.activityIndicator.startLoading()
        if(self.publicPost.isOn) {
            self.selectedEvent = generalEvent
        }
        let postToCreate = Post(message: postMessageText.text, date: Date())
        postToCreate.idev = selectedEvent.idev
        postToCreate.idas = connectedAsso?.idas
        self.postWS.newPost(post: postToCreate) { (sucess) in
            if (sucess || checkCallback) {
                self.postWS.getPosts(idAsso: (self.connectedAsso?.idas)!) { (posts) in
                    self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso!.idas!) { (events) in
                        self.userWS.getUsers { (users) in
                            checkCallback = true
                            self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, connectedAsso: self.connectedAsso, events: events, users: users), animated: false)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopLoading()
                    self.errorTextField.isHidden = false
                }
            }
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
        eventTextField.text = eventNamesList![row] == "" ? "Aucun" : eventNamesList![row]
        selectedEvent = eventList[row]
        self.view.endEditing(true)
    }
    
    
}
