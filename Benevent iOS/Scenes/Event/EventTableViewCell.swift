//
//  EventTableViewCell.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 04/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet var dataView: UIView!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventStartDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
