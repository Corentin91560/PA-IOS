//
//  User.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit


class Association: CustomStringConvertible {
    var idas: Int?
    var name: String
    var logo: UIImage?
    var acronym: String?
    var email: String
    var phone: String?
    var website: String?
    var support: String?
    var password: String
    var idcat: Int?
 
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    
    var description: String {
        return "{\(self.idas ?? 0) \(self.name) \(self.acronym ?? "") \(self.email)  \(self.phone ?? "") \(self.website ?? "") \(self.support ?? "") \(self.password) \(self.idcat ?? 0)}"
    }
}
