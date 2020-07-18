//
//  EventParticipantsViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 11/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private enum Identifier: String {
          case participants
      }
    
    @IBOutlet private var tableView: UITableView!
    
    private var participants : [User]!
    
    static func newInstance(participants: [User]) -> EventParticipantsViewController {
        let eventParticipantsVC: EventParticipantsViewController = EventParticipantsViewController()
        eventParticipantsVC.participants = participants
        return eventParticipantsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupTableView() {
       tableView.allowsSelection = false
       tableView.register(UINib(nibName: "EventParticipantsTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.participants.rawValue)
       tableView.dataSource = self
       tableView.delegate = self
       tableView.separatorStyle = .none
    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
        navigationItem.title = "Liste des participants"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "SF_multiply_circle_fill"),
            style: .plain,
            target: self,
            action: #selector(Back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.participants.rawValue, for: indexPath) as! EventParticipantsTableViewCell
        let participant = participants[indexPath.row]
        cell.participantFullname.text = "\(participant.getFirstname()) \(participant.getName())"
        cell.participantPicture.load(url: URL(string: participant.getProfilePicture())!)
        cell.participantPicture.frame = CGRect(x: 120, y: 30, width: 125, height: 125)
        return cell
    }
}
