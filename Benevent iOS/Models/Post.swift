//
//  Post.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit


class Post: CustomStringConvertible {

    var idPost: Int?
    var message: String
    var date: Date
    var idUser: Int?
    var idAssociation: Int?
    var idEvent: Int?
 
    init(message: String, date: Date) {
        self.message = message
        self.date = date
    }
    
    
    var description: String {
        return "{\(self.idPost ?? 0) \(self.message) \(self.date) \(self.idUser ?? 0)  \(self.idAssociation ?? 0) \(self.idEvent ?? 0)}"
    }
}
