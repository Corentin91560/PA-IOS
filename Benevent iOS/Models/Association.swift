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
    var idAssociation: Int?
    var name: String
    var logo: String?
    var acronym: String?
    var email: String
    var phone: String?
    var website: String?
    var support: String?
    var password: String
    var idCategory: Int?
 
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    
    var description: String {
        return "{\(self.idAssociation ?? 0) \(self.name) \(self.logo ?? AppConfig.basicAssociationLogoURL) \(self.acronym ?? "") \(self.email)  \(self.phone ?? "") \(self.website ?? "") \(self.support ?? "") \(self.password) \(self.idCategory ?? 0)}"
    }
}
