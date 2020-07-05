//
//  HomeViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    enum Identifier: String {
        case posts
    }
    
    @IBOutlet var myTabBar: UITabBar!
    @IBOutlet var dataTableView: UITableView!
    
    var posts: [Post]!
    var connectedAsso: Association? = nil
    var eventWS: EventWebService = EventWebService()

    class func newInstance(posts: [Post]) -> HomeViewController {
        let hvc = HomeViewController()
        hvc.posts = posts
        return hvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.dataTableView.separatorStyle = .none
        viewDidLayoutSubviews()
        setupNavigationBar()
        myTabBar.selectedItem = myTabBar.items?[0]
        self.dataTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.posts.rawValue)
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.myTabBar.delegate = self
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTabBar.frame.size.height = 90
        myTabBar.frame.origin.y = view.frame.height - 90
    }
    
    func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Fil d'actualité"
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
            action: #selector(addPost))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        
    }
    
    @objc func addPost() {
        self.eventWS.getEventsByAssociation(idAsso: connectedAsso!.idas!) { (events) in
            let CreatePostVC = CreatePostViewController.newInstance(events: events)
            CreatePostVC.connectedAsso = self.connectedAsso
            self.navigationController?.pushViewController(CreatePostVC, animated: true)
        }
    }
    
    @objc func Profile() {
        let ProfileVC = ProfileViewController()
        ProfileVC.connectedAsso = self.connectedAsso
        self.navigationController?.pushViewController(ProfileVC, animated: false)
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.selectedItem == tabBar.items?[1]) {
            self.eventWS.getEventsByAssociation(idAsso: (connectedAsso?.idas!)!) { (eventsList) in
                    let EventVC = EventViewController.newInstance(events: eventsList, connectedAsso: self.connectedAsso!)
                    self.navigationController?.pushViewController(EventVC, animated: false)
                }
            } else if (tabBar.selectedItem == tabBar.items?[2]) {
                let feedbackVC = FeedbackViewController()
                navigationController?.pushViewController(feedbackVC, animated: true)
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.posts.rawValue, for: indexPath) as! HomeTableViewCell
        let post = self.posts[indexPath.row]
        
        formatter.dateFormat = "dd/MM/yyyy"
        cell.assoName.text = connectedAsso?.name
        cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
        cell.postMessage.text = post.message
        cell.dataView.layer.cornerRadius = 50
        cell.assoProfilePicture.frame = CGRect(x: 20, y: 20, width: 75, height: 75)
        cell.assoProfilePicture.load(url: URL(string: (connectedAsso?.logo)!)!)
        cell.postDate.text = "le \(formatter.string(from: post.date))"
        self.eventWS.getEvent(idEvent: post.idev!) { (event) in
            cell.eventName.text = event[0].name
        }
        return cell
    }
}

