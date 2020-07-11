//
//  EventViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    enum Identifier: String {
         case events
    }
    
    var events: [Event]!
    var usableEvents : [Event]!
    var connectedAsso: Association?

    let eventsWS: EventWebService = EventWebService()
    let postsWS: PostWebService = PostWebService()
    let categoryWS: CategoryWebService = CategoryWebService()
    let userWS: UserWebService = UserWebService()
    
    @IBOutlet var myTabBar: UITabBar!
    @IBOutlet var dataTableView: UITableView!
    
    class func newInstance(events: [Event], connectedAsso: Association) -> EventViewController {
        let evc = EventViewController()
        evc.events = events
        evc.usableEvents = events.filter({!$0.fakeEvent!})
        evc.connectedAsso = connectedAsso
        return evc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        setupTableView()
        myTabBar.selectedItem = myTabBar.items?[1]
        self.myTabBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          myTabBar.frame.size.height = 90
          myTabBar.frame.origin.y = view.frame.height - 90
      }
    
    func setupTableView() {
        self.dataTableView.separatorStyle = .none
        self.dataTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.events.rawValue)
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Mes évenements"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "person.fill"),
        style: .plain,
        target: self,
        action: #selector(Profile))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(createEvent))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func createEvent() {
        let generalEvent = events.filter{ $0.fakeEvent! == true}[0]
        self.categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(CreateEventViewController.newInstance(categories: categories, connectedAsso: self.connectedAsso, generalEvent: generalEvent), animated: true)
        }
    }
      
    @objc func Profile() {
        self.navigationController?.pushViewController(ProfileViewController.newInstance(connectedAsso: self.connectedAsso), animated: false)
      //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       if (tabBar.selectedItem == tabBar.items?[0]) {
            self.postsWS.getPosts(idAsso: connectedAsso!.idas!) { (posts) in
                self.userWS.getUsers { (users) in
                    self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts,connectedAsso: self.connectedAsso, events: self.events, users: users), animated: false)
                }
            }
        } else if (tabBar.selectedItem == tabBar.items?[2]) {
            navigationController?.pushViewController(FeedbackViewController.newInstance(connectedAsso: self.connectedAsso), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usableEvents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.events.rawValue, for: indexPath) as! EventTableViewCell
        let event = self.usableEvents[indexPath.row]
        let now = Date()
        formatter.dateFormat = "dd/MM/yyyy"
        
        cell.dataView.layer.cornerRadius = 50
        cell.arrowImage.frame = CGRect(x: 918, y: 52, width: 75, height: 75)
        cell.eventName.text = event.name
        
        if (event.startDate < now && event.endDate > now) {
            cell.eventStartDate.text = "En cours depuis le \(formatter.string(from: event.startDate))"
        } else if (event.startDate > now) {
            cell.eventStartDate.textColor = UIColor.systemGreen
            cell.eventStartDate.text = "Débutera le \(formatter.string(from: event.startDate))"
        } else {
            cell.eventStartDate.textColor = UIColor.systemRed
            cell.eventStartDate.text = "Evénement terminé le \(formatter.string(from: event.endDate))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(EventDetailViewController.newInstance(connectedAsso: self.connectedAsso!, event: self.events[indexPath.row], categories: categories), animated: true)
        }
        
    }

}
