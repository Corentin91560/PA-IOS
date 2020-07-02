//
//  HomeTableViewCell.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var assoProfilePicture: UIImageView!
    @IBOutlet var dataView: UIView!
    @IBOutlet var assoName: UILabel!
    @IBOutlet var postMessage: UILabel!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var postDate: UILabel!
    
    let connectedAsso: Association? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
