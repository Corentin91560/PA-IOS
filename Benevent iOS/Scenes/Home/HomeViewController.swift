//
//  HomeViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Identifier: String {
        case posts
    }
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var dataTableView: UITableView!
    
    var posts: [Post]!
    var connectedAsso: Association? = nil
    var postWS: PostWebService = PostWebService()

    class func newInstance(posts: [Post]) -> HomeViewController {
        let hvc = HomeViewController()
        hvc.posts = posts
        return hvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        viewDidLayoutSubviews()
        setupNavigationBar()
        tabBar.selectedItem = tabBar.items?[0]
        self.dataTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.posts.rawValue)
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 90
        tabBar.frame.origin.y = view.frame.height - 90
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
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche 
    }
    
    @objc func Profile() {
        let ProfileVC = ProfileViewController()
        ProfileVC.connectedAsso = self.connectedAsso
        self.navigationController?.pushViewController(ProfileVC, animated: false)
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.posts.rawValue, for: indexPath) as! HomeTableViewCell
        let post = self.posts[indexPath.row]
        cell.assoName.text = connectedAsso?.name
        cell.assoName.font = UIFont.boldSystemFont(ofSize: 20)
        cell.postMessage.text = post.message
        cell.dataView.layer.cornerRadius = 50
        cell.assoProfilePicture.load(url: URL(string: (connectedAsso?.logo)!)!)
        return cell
    }
}

