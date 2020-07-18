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
    
    private var events: [Event]!
    private var connectedAssociation: Association!
    private var generalEvent: Event!
    
    private let eventsWS: EventWebService = EventWebService()
    private let postsWS: PostWebService = PostWebService()
    private let categoryWS: CategoryWebService = CategoryWebService()
    private let userWS: UserWebService = UserWebService()
    
    @IBOutlet private var myTabBar: UITabBar!
    @IBOutlet private var dataTableView: UITableView!
    
    class func newInstance(events: [Event]) -> EventViewController {
        let eventVC = EventViewController()
        eventVC.events = self.sortEvents(events: events.filter{ !$0.getFakeEvent() })
        eventVC.generalEvent = events.filter{ $0.getFakeEvent() == true }[0]
        eventVC.connectedAssociation = AppConfig.connectedAssociation
        return eventVC
    }
    
    private class func sortEvents(events: [Event]) -> [Event] {
        let now = Date().now()
        return events.filter{ $0.isInProgress() } + events.filter{ $0.getStartDate() > now } + events.filter{ $0.getEndDate() < now }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        setupTableView()
        myTabBar.selectedItem = myTabBar.items?[1]
        myTabBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          myTabBar.frame.size.height = 90
          myTabBar.frame.origin.y = view.frame.height - 90
      }
    
    private func setupTableView() {
       dataTableView.separatorStyle = .none
       dataTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.events.rawValue)
       dataTableView.dataSource = self
       dataTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Mes événements"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "SF_person_crop_square_fill"),
        style: .plain,
        target: self,
        action: #selector(Profile))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_plus_square_on_square_fill"),
            style: .plain,
            target: self,
            action: #selector(createEvent))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         if (tabBar.selectedItem == tabBar.items?[0]) {
            postsWS.getPosts(idAsso: self.connectedAssociation.getIdAssociation()) { (posts) in
                self.userWS.getUsersByIdAsso(idAsso: self.connectedAssociation.getIdAssociation()) { (users) in
                    self.events.append(self.generalEvent)
                    self.navigationController?.pushViewController(HomeViewController.newInstance(posts: posts, events: self.events, users: users), animated: false)
                  }
              }
          } else if (tabBar.selectedItem == tabBar.items?[2]) {
              navigationController?.pushViewController(FeedbackViewController(), animated: false)
          }
      }
    
    @objc private func createEvent() {
        categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(CreateEventViewController.newInstance(categories: categories, generalEvent: self.generalEvent), animated: true)
        }
    }
      
    @objc private func Profile() {
        navigationController?.pushViewController(ProfileViewController(), animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let now = Date().now()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.events.rawValue, for: indexPath) as! EventTableViewCell
        let event = self.events[indexPath.row]
        
        cell.dataView.layer.cornerRadius = 50
        cell.arrowImage.frame = CGRect(x: 918, y: 52, width: 75, height: 75)
        cell.eventName.text = event.getName()
        
        if (event.isInProgress()) {
            cell.eventStartDate.textColor = UIColor.systemGray
            cell.eventStartDate.text = "En cours depuis le \(formatter.string(from: event.getStartDate()))"
        } else if (event.getStartDate() > now) {
            cell.eventStartDate.textColor = UIColor.systemGreen
            cell.eventStartDate.text = "Débutera le \(formatter.string(from: event.getStartDate()))"
        } else {
            cell.eventStartDate.textColor = UIColor.systemRed
            cell.eventStartDate.text = "Evénement terminé le \(formatter.string(from: event.getEndDate()))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryWS.getCategories { (categories) in
            self.navigationController?.pushViewController(EventDetailViewController.newInstance(event: self.events[indexPath.row], categories: categories), animated: true)
        }
    }
}
