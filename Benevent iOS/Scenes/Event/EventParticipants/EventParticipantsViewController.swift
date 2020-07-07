//
//  EventParticipantsViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventParticipantsViewController: UIViewController {

    var participants: [User]!
    
    class func newInstance(users: [User]) -> EventParticipantsViewController {
        let EventParticipantsVC: EventParticipantsViewController = EventParticipantsViewController()
        EventParticipantsVC.participants = users
        return EventParticipantsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
