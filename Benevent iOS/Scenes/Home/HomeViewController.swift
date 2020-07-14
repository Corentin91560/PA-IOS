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
    
    let eventWS: EventWebService = EventWebService()
    let userWS: UserWebService = UserWebService()
    let postWS: PostWebService = PostWebService()
    
    var posts: [Post]!
    var connectedAsso: Association? = nil
    var events: [Event]!
    var users: [User]!
    
    let refreshControl = UIRefreshControl()
    
    class func newInstance(posts: [Post], connectedAsso: Association?, events: [Event], users: [User]) -> HomeViewController {
        let hvc = HomeViewController()
        hvc.posts = posts
        hvc.connectedAsso = connectedAsso
        hvc.events = events
        hvc.users = users
        return hvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        viewDidLayoutSubviews()
        setupNavigationBar()
        setupTabBar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.myTabBar.frame.size.height = 90
        self.myTabBar.frame.origin.y = view.frame.height - 90
    }
    
    func setupTabBar() {
        self.myTabBar.selectedItem = myTabBar.items?[0]
        self.myTabBar.delegate = self
    }
    
    func setupTableView() {
        self.dataTableView.allowsSelection = false
        self.dataTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.posts.rawValue)
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.dataTableView.separatorStyle = .none
        self.dataTableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Fil d'actualité"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
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
    
    @objc func addPost() {
        self.eventWS.getEventsByAssociation(idAsso: connectedAsso!.idas!) { (events) in
            self.navigationController?.pushViewController(CreatePostViewController.newInstance(events: events, connectedAsso: self.connectedAsso), animated: true)
        }
    }
    
    @objc func Profile() {
        self.navigationController?.pushViewController(ProfileViewController.newInstance(connectedAsso: self.connectedAsso), animated: false)
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
    }
    
    @objc func refreshData() {
        self.postWS.getPosts(idAsso: connectedAsso!.idas!) { (posts) in
            self.posts = posts
        }
        DispatchQueue.main.async {
            self.dataTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (tabBar.selectedItem == tabBar.items?[1]) {
            self.eventWS.getEventsByAssociation(idAsso: (connectedAsso?.idas!)!) { (eventsList) in
                    self.navigationController?.pushViewController(EventViewController.newInstance(events: eventsList, connectedAsso: self.connectedAsso!), animated: false)
                }
            } else if (tabBar.selectedItem == tabBar.items?[2]) {
                navigationController?.pushViewController(FeedbackViewController.newInstance(connectedAsso: self.connectedAsso), animated: false)
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            var checkCallback = false
            let post = self.posts[indexPath.row]
            self.postWS.deletePost(idPost: post.idpo!) { (sucess) in
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
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = "HH:mm"
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.posts.rawValue, for: indexPath) as! HomeTableViewCell
        let post = self.posts[indexPath.row]
        var event: Event!
        for e in self.events {
            if (e.idev! == post.idev!) {
                event = e
            }
        }
        if(post.idas != nil) {
            cell.assoName.text = connectedAsso?.name
            cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
            cell.assoProfilePicture.load(url: URL(string: (connectedAsso?.logo)!)!)
        } else {
            let user = self.users.filter{ $0.idu! == post.idu!}[0]
            cell.assoName.text = "\(user.firstName) \(user.name)"
            cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
            cell.assoProfilePicture.load(url: URL(string: user.profilePicture!)!)
        }
        cell.assoProfilePicture.layer.cornerRadius = 25
        cell.postMessage.text = post.message
        cell.dataView.layer.cornerRadius = 50
        cell.assoProfilePicture.frame = CGRect(x: 20, y: 20, width: 75, height: 75)
        cell.postDate.text = "le \(formatterDate.string(from: post.date)) à \(formatterHour.string(from: post.date))"
        cell.eventName.text = event.name
        return cell
    }
}

