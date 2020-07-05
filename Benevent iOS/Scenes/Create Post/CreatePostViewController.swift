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
    
    let postWS : PostWebService = PostWebService()
    
    var connectedAsso: Association? = nil
    var eventList: [Event]!
    var eventPicker: UIPickerView!
    var eventNamesList: [String]? = nil
    var selectedEvent: Event!
    
    class func newInstance(events: [Event]) -> CreatePostViewController {
        let newPostVC = CreatePostViewController()
        newPostVC.eventList = events
        return newPostVC
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupPicker()
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
        self.navigationItem.title = "Créer un post"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
       
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "x.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @IBAction func Valid(_ sender: Any) {
        let postToCreate = Post(message: postMessageText.text, date: Date())
        postToCreate.idev = selectedEvent.idev
        postToCreate.idas = connectedAsso?.idas
        self.postWS.newPost(post: postToCreate) { (sucess) in
            if (sucess) {
                self.postWS.getPosts(idAsso: (self.connectedAsso?.idas)!) { (posts) in
                    let HomeVC = HomeViewController.newInstance(posts: posts)
                    HomeVC.connectedAsso = self.connectedAsso
                    self.navigationController?.pushViewController(HomeVC, animated: false)
                }
            } else {
                DispatchQueue.main.async {
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
        return eventNamesList![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventTextField.text = eventNamesList![row]
        selectedEvent = eventList[row]
        self.view.endEditing(true)
    }
    
    
}
