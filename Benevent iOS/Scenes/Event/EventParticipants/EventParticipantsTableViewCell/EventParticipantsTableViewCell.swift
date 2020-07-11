//
//  EventParticipantsTableViewCell.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 11/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventParticipantsTableViewCell: UITableViewCell {
    @IBOutlet var dataView: UIView!
    @IBOutlet var participantPicture: UIImageView!
    @IBOutlet var participantFullname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
