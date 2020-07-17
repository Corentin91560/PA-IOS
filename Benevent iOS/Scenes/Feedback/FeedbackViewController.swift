//
//  FeedbackViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet var myTabBar: UITabBar!
    @IBOutlet var viewControl: UISegmentedControl!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // BUG VIEW
    @IBOutlet var bugView: UIView!
    @IBOutlet var bugTitle: UITextField!
    @IBOutlet var bugDescription: UITextView!
    @IBOutlet var sendBugButton: UIButton!
    
    // IMPROVEMENT VIEW
    @IBOutlet var improvementView: UIView!
    @IBOutlet var noteSlider: UISlider!
    @IBOutlet var improvementDescrition: UITextView!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var sendImprovementButton: UIButton!
    
    let userWS: UserWebService = UserWebService()
    let postsWS: PostWebService = PostWebService()
    let eventWS: EventWebService = EventWebService()
    let feedbackWS: FeedbackWebService = FeedbackWebService()
    
    var connectedAsso: Association?
    
    class func newInstance(connectedAsso: Association?) -> FeedbackViewController {
        let FeedbackVC: FeedbackViewController = FeedbackViewController()
        FeedbackVC.connectedAsso = connectedAsso
        return FeedbackVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        self.activityIndicator.isHidden = true
        self.resultLabel.isHidden = true
        self.improvementView.isHidden = true
        self.sendBugButton.layer.cornerRadius = self.sendBugButton.bounds.size.height/2
        self.sendImprovementButton.layer.cornerRadius = self.sendImprovementButton.bounds.size.height/2
        setupNavigationBar()
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          self.myTabBar.frame.size.height = 90
          self.myTabBar.frame.origin.y = view.frame.height - 90
      }
    
    func setupTabBar() {
        self.myTabBar.selectedItem = myTabBar.items?[2]
        self.myTabBar.delegate = self
    }
    
    func setupNavigationBar() {
           self.navigationItem.hidesBackButton = true
           self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
           self.navigationItem.title = "Feedback"
           self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
           
           self.navigationItem.leftBarButtonItem = UIBarButtonItem(
           image: UIImage(named: "SF_person_crop_square_fill"),
           style: .plain,
           target: self,
           action: #selector(Profile))
           self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
                      
       }

       @objc func Profile() {
           self.navigationController?.pushViewController(ProfileViewController.newInstance(connectedAsso: self.connectedAsso), animated: false)
           //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
       }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       if (tabBar.selectedItem == tabBar.items?[0]) {
            self.postsWS.getPosts(idAsso: connectedAsso!.idAssociation!) { (posts) in
                self.userWS.getUsersByIdAsso(idAsso: self.connectedAsso!.idAssociation!) { (users) in
                 self.eventWS.getEventsByAssociation(idAsso: (self.connectedAsso?.idAssociation!)!) { (events) in
                     self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts,connectedAsso: self.connectedAsso, events: events, users: users), animated: false)
                 }
                }
            }
        } else if (tabBar.selectedItem == tabBar.items?[1]) {
             self.eventWS.getEventsByAssociation(idAsso: (connectedAsso?.idAssociation!)!) { (eventsList) in
                 self.navigationController?.pushViewController(EventViewController.newInstance(events: eventsList, connectedAsso: self.connectedAsso!), animated: false)
             }
        }
    }
    
    @IBAction func viewControlChange(_ sender: Any) {
        self.resultLabel.isHidden = true
        if(viewControl.selectedSegmentIndex == 0) {
            self.improvementView.isHidden = true
            self.bugView.isHidden = false
        } else if (viewControl.selectedSegmentIndex == 1) {
            self.bugView.isHidden = true
            self.improvementView.isHidden = false
        
        }
    }
    
    @IBAction func noteChange(_ sender: Any) {
        self.noteLabel.text = "\(Int(self.noteSlider.value))/5"
    }
    @IBAction func sendEvaluation(_ sender: Any) {
        var checkCallback = false
        let feedbackToCreate: Feedback = Feedback(content: self.improvementDescrition.text, date: Date())
        feedbackToCreate.idAssociation = self.connectedAsso?.idAssociation!
        feedbackToCreate.idType = 2
        feedbackToCreate.note = Int(self.noteSlider.value)
        print("SEND EVAL : \(feedbackToCreate.description)")
        if(self.improvementDescrition.text == "") {
            self.resultLabel.isHidden = false
            self.resultLabel.text = "Les champs sont obligatoires !"
            self.resultLabel.textColor = UIColor.systemRed
        } else {
            self.activityIndicator.startLoading()
            self.feedbackWS.newFeedback(feedback: feedbackToCreate) { (sucess) in
                DispatchQueue.main.sync {
                    if(sucess || checkCallback) {
                        self.cleanView()
                        self.resultLabel.isHidden = false
                        self.resultLabel.text = "Evaluation envoyée !"
                        self.resultLabel.textColor = UIColor.systemGreen
                        checkCallback = true
                    } else {
                        self.sendingError()
                    }
                }
            }
            self.activityIndicator.stopLoading()
        }
    }
    
    @IBAction func sendBug(_ sender: Any) {
        var checkCallback = false
        let feedbackToCreate: Feedback = Feedback(content: self.bugDescription.text, date: Date().now())
        feedbackToCreate.idAssociation = self.connectedAsso?.idAssociation!
        feedbackToCreate.idType = 1
        feedbackToCreate.title = self.bugTitle.text!
        print("SEND BUG : \(feedbackToCreate.description)")
        if(self.bugTitle.text == "" || self.bugDescription.text == "") {
            self.resultLabel.isHidden = false
            self.resultLabel.text = "Les champs sont obligatoires !"
            self.resultLabel.textColor = UIColor.systemRed
        } else {
            self.activityIndicator.startLoading()
            self.feedbackWS.newFeedback(feedback: feedbackToCreate) { (sucess) in
                DispatchQueue.main.sync {
                    if(sucess || checkCallback) {
                        checkCallback = true
                        self.cleanView()
                        self.resultLabel.isHidden = false
                        self.resultLabel.text = "Bug envoyé !"
                        self.resultLabel.textColor = UIColor.systemGreen
                    } else {
                        self.sendingError()
                    }
                }
            }
            self.activityIndicator.stopLoading()
        }
    }
    
    func cleanView()
    {
        self.bugDescription.text = ""
        self.bugTitle.text = ""
        self.improvementDescrition.text = ""
        self.noteSlider.value = 5
        self.noteLabel.text = "5/5"
    }
    
    func sendingError() {
        self.resultLabel.isHidden = false
        self.resultLabel.text = "Erreur lors de l'envoi du feedback !"
        self.resultLabel.textColor = UIColor.systemRed
    }
}
