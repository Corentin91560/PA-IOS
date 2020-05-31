//
//  SignupViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet var assoNameTF: UITextField!
    @IBOutlet var assoEmailTF: UITextField!
    @IBOutlet var assoPwdTF: UITextField!
    @IBOutlet var assoConfirmPwdLabel: UITextField!
    @IBOutlet var validButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func Confirm(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
