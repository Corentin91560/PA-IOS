//
//  EventParticipantsViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 11/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Identifier: String {
          case participants
      }
    
    @IBOutlet var tableView: UITableView!
    
    var participants : [User]!
    
    static func newInstance(participants: [User]) -> EventParticipantsViewController {
        let EPVC: EventParticipantsViewController = EventParticipantsViewController()
        EPVC.participants = participants
        return EPVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
    }
    
    func setupTableView() {
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "EventParticipantsTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.participants.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }

    func setupNavigationBar() {
         // Navigation bar main config
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        self.navigationItem.title = "Liste des participants"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
        // Left item config
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "x.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        }
    
    @objc func Back() {
        self.navigationController?.popViewController(animated: false)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.participants.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.participants.rawValue, for: indexPath) as! EventParticipantsTableViewCell
        let participant = self.participants[indexPath.row]
        cell.participantFullname.text = "\(participant.firstName) \(participant.name)"
        cell.participantPicture.load(url: URL(string: participant.profilePicture!)!)
        cell.participantPicture.frame = CGRect(x: 120, y: 30, width: 125, height: 125)
        return cell
    }
}
