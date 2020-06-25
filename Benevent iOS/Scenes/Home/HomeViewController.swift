//
//  HomeViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
 
    
   
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var dataTableView: UITableView!
    
    var connectedAsso: Association? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviews()
        setupNavigationBar()
        /*self.dataTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "CellFromNib")
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self*/
        tabBar.selectedItem = tabBar.items?[0]
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 90
        tabBar.frame.origin.y = view.frame.height - 90
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "SunGlow")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Déconnexion",
            style: .plain,
            target: self,
            action: #selector(Disconnect))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        self.navigationItem.hidesBackButton = true;
    }
    
    @objc func Disconnect() {
        let LoginVC = LoginViewController()
        self.navigationController?.pushViewController(LoginVC, animated: false)
        //TODO: Modifier le changement de vue afin qu'il se fasse de droite à gauche 
    }
    
}

