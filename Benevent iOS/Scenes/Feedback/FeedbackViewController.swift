//
//  FeedbackViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITabBarDelegate {
    
    private let userWS: UserWebService = UserWebService()
    private let postsWS: PostWebService = PostWebService()
    private let eventWS: EventWebService = EventWebService()
    private let feedbackWS: FeedbackWebService = FeedbackWebService()
    
    private var connectedAsso: Association!
    
    @IBOutlet private var myTabBar: UITabBar!
    @IBOutlet private var viewSelector: UISegmentedControl!
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // BUG VIEW
    @IBOutlet private var bugView: UIView!
    @IBOutlet private var bugTitle: UITextField!
    @IBOutlet private var bugDescription: UITextView!
    @IBOutlet private var sendBugButton: UIButton!
    
    // RATING VIEW
    @IBOutlet private var ratingView: UIView!
    @IBOutlet private var noteSlider: UISlider!
    @IBOutlet private var ratingDescription: UITextView!
    @IBOutlet private var noteLabel: UILabel!
    @IBOutlet private var sendRatingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedAsso = AppConfig.connectedAssociation
        setupView()
    }
    
    private func setupView() {
        hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        activityIndicator.isHidden = true
        resultLabel.isHidden = true
        ratingView.isHidden = true
        sendBugButton.layer.cornerRadius = self.sendBugButton.bounds.size.height/2
        sendRatingButton.layer.cornerRadius = self.sendRatingButton.bounds.size.height/2
        setupNavigationBar()
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          myTabBar.frame.size.height = 90
          myTabBar.frame.origin.y = view.frame.height - 90
      }
    
    private func setupTabBar() {
        myTabBar.selectedItem = myTabBar.items?[2]
        myTabBar.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Feedback"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
           image: UIImage(named: "SF_person_crop_square_fill"),
           style: .plain,
           target: self,
           action: #selector(Profile))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
       }
    
    private func cleanView() {
       bugDescription.text = ""
       bugTitle.text = ""
       ratingDescription.text = ""
       noteSlider.value = 5
       noteLabel.text = "5/5"
    }
    
    private func sendingError() {
        resultLabel.isHidden = false
        resultLabel.text = "Erreur lors de l'envoi du feedback !"
        resultLabel.textColor = UIColor.systemRed
    }

    @objc private func Profile() {
       navigationController?.pushViewController(ProfileViewController(), animated: false)
    }
    
    @IBAction private func viewControlChange(_ sender: Any) {
        resultLabel.isHidden = true
        if(viewSelector.selectedSegmentIndex == 0) {
            ratingView.isHidden = true
            bugView.isHidden = false
        } else if (viewSelector.selectedSegmentIndex == 1) {
            bugView.isHidden = true
            ratingView.isHidden = false
        
        }
    }
    
    @IBAction private func noteChange(_ sender: Any) {
        noteLabel.text = "\(Int(self.noteSlider.value))/5"
    }
    
    @IBAction private func sendEvaluation(_ sender: Any) {
        var checkCallback = false
        let feedbackToCreate: Feedback = Feedback(content: self.ratingDescription.text, date: Date())
        feedbackToCreate.setIdAssociation(idAssociation: self.connectedAsso.getIdAssociation())
        feedbackToCreate.setIdType(idType: 2)
        feedbackToCreate.setNote(note: Int(self.noteSlider.value))
        if(ratingDescription.text == "") {
            resultLabel.isHidden = false
            resultLabel.text = "Les champs sont obligatoires !"
            resultLabel.textColor = UIColor.systemRed
        } else {
            activityIndicator.startLoading()
            feedbackWS.newFeedback(feedback: feedbackToCreate) { (sucess) in
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
            activityIndicator.stopLoading()
        }
    }
    
    @IBAction private func sendBug(_ sender: Any) {
        var checkCallback = false
        let feedbackToCreate: Feedback = Feedback(content: self.bugDescription.text, date: Date().now())
        feedbackToCreate.setIdAssociation(idAssociation: self.connectedAsso.getIdAssociation())
        feedbackToCreate.setIdType(idType: 1)
        feedbackToCreate.setTitle(title: self.bugTitle.text!)
        if(self.bugTitle.text == "" || self.bugDescription.text == "") {
           resultLabel.isHidden = false
           resultLabel.text = "Les champs sont obligatoires !"
           resultLabel.textColor = UIColor.systemRed
        } else {
            activityIndicator.startLoading()
            feedbackWS.newFeedback(feedback: feedbackToCreate) { (sucess) in
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
            activityIndicator.stopLoading()
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       if (tabBar.selectedItem == tabBar.items?[0]) {
            postsWS.getPosts(idAsso: connectedAsso.getIdAssociation()) { (posts) in
                self.userWS.getUsersByIdAsso(idAsso: self.connectedAsso.getIdAssociation()) { (users) in
                    self.eventWS.getEventsByAssociation(idAsso: self.connectedAsso.getIdAssociation()) { (events) in
                     self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, events: events, users: users), animated: false)
                 }
                }
            }
        } else if (tabBar.selectedItem == tabBar.items?[1]) {
        eventWS.getEventsByAssociation(idAsso: connectedAsso.getIdAssociation()) { (eventsList) in
                 self.navigationController?.pushViewController(EventViewController.newInstance(events: eventsList), animated: false)
             }
        }
    }
}
