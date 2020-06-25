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

    var idpo: Int?
    var message: String
    var date: Date
    var idu: Int?
    var idas: Int?
    var idev: Int?
 
    init(message: String, date: Date) {
        self.message = message
        self.date = date
    }
    
    
    var description: String {
        return "{\(self.idpo ?? 0) \(self.message) \(self.date) \(self.idu ?? 0)  \(self.idas ?? 0) \(self.idev ?? 0)}"
    }
}
