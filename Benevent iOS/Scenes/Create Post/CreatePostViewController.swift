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
    
    var connectedAsso: Association? = nil
    let eventWS: EventWebService = EventWebService()
    var eventList: [Event]!
    var eventPicker: UIPickerView!
    var eventNamesList: [String]? = nil
    
    class func newInstance(events: [Event]) -> CreatePostViewController {
        let newPostVC = CreatePostViewController()
        newPostVC.eventList = events
        return newPostVC
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupPicker()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupPicker() {
        for e in eventList {
            print(e.name)
            eventNamesList?.append(e.name)
        }
        eventPicker = UIPickerView()
        eventPicker.dataSource = self
        eventPicker.delegate = self
        eventTextField.inputView = eventPicker
        print("EventNamesList[0] \(eventNamesList?[0])")
        eventTextField.text = self.eventNamesList?[0]
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
        self.view.endEditing(true)
    }
    
    
}
