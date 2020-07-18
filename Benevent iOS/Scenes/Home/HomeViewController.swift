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
    
    
    private let eventWS: EventWebService = EventWebService()
    private let userWS: UserWebService = UserWebService()
    private let postWS: PostWebService = PostWebService()
    
    private var posts: [Post]!
    private var events: [Event]!
    private var users: [User]!
    
    @IBOutlet private var myTabBar: UITabBar!
    @IBOutlet private var dataTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var connectedAssociation: Association!
    
    class func newInstance(posts: [Post], events: [Event], users: [User]) -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.posts = posts
        homeVC.events = events
        homeVC.users = users
        homeVC.connectedAssociation = AppConfig.connectedAssociation
        return homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        setupNavigationBar()
        setupTabBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTabBar.frame.size.height = 90
        myTabBar.frame.origin.y = view.frame.height - 90
    }
    
    private func setupTabBar() {
        myTabBar.selectedItem = myTabBar.items?[0]
        myTabBar.delegate = self
    }
    
    private func setupTableView() {
        dataTableView.allowsSelection = false
        dataTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.posts.rawValue)
        dataTableView.dataSource = self
        dataTableView.delegate = self
        dataTableView.separatorStyle = .none
        dataTableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Fil d'actualité"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_person_crop_square_fill"),
            style: .plain,
            target: self,
            action: #selector(Profile))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_plus_square_on_square_fill"),
            style: .plain,
            target: self,
            action: #selector(addPost))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       if (tabBar.selectedItem == tabBar.items![1]) {
           eventWS.getEventsByAssociation(idAsso: (connectedAssociation.getIdAssociation())) { (eventsList) in
                   self.navigationController?.pushViewController(EventViewController.newInstance(events: eventsList), animated: false)
           }
       } else if (tabBar.selectedItem == tabBar.items![2]) {
            navigationController?.pushViewController(FeedbackViewController(), animated: false)
       }
    }
       
    @objc private func addPost() {
        eventWS.getEventsByAssociation(idAsso: connectedAssociation.getIdAssociation()) { (events) in
            self.navigationController?.pushViewController(CreatePostViewController.newInstance(events: events), animated: true)
        }
    }
    
    @objc private func Profile() {
        navigationController?.pushViewController(ProfileViewController(), animated: false)
    }
    
    @objc private func refreshData() {
        postWS.getPosts(idAsso: self.connectedAssociation.getIdAssociation()) { (posts) in
            self.eventWS.getEventsByAssociation(idAsso: self.connectedAssociation.getIdAssociation()) { (events) in
                self.userWS.getUsersByIdAsso(idAsso: self.connectedAssociation.getIdAssociation()) { (users) in
                    self.posts = posts
                    self.events = events
                    self.users = users
                }
            }
        }
        DispatchQueue.main.async {
            self.dataTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            var checkCallback = false
            let post = self.posts[indexPath.row]
            postWS.deletePost(idPost: post.getIdPost()) { (sucess) in
                if(sucess || checkCallback) {
                    checkCallback = true
                    self.posts.remove(at: indexPath.row)
                    DispatchQueue.main.sync {
                        self.dataTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.dataTableView.reloadData()
                    }
                }
            }
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy"
        formatterDate.timeZone = TimeZone(abbreviation: "UTC")
        
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = "HH:mm"
        formatterHour.timeZone = TimeZone(abbreviation: "UTC")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.posts.rawValue, for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let event = events.filter{ $0.getIdEvent() == post.getIdEvent() }[0]
        
        if(post.getIdAssociation() != nil) {
            cell.assoName.text = connectedAssociation.getName()
            cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
            cell.assoProfilePicture.load(url: URL(string: connectedAssociation.getLogo())!)
        } else {
            let user = users.filter{ $0.getIdUser() == post.getIdUser()!}[0]
            cell.assoName.text = "\(user.getFirstname()) \(user.getName())"
            cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
            cell.assoProfilePicture.load(url: URL(string: user.getProfilePicture())!)
        }
        
        cell.assoProfilePicture.layer.cornerRadius = 25
        cell.postMessage.text = post.getMessage()
        cell.dataView.layer.cornerRadius = 50
        cell.assoProfilePicture.frame = CGRect(x: 20, y: 40, width: 75, height: 75)
        cell.postDate.text = "le \(formatterDate.string(from: post.getDate())) à \(formatterHour.string(from: post.getDate()))"
        cell.eventName.text = event.getName()
        return cell
    }
}

