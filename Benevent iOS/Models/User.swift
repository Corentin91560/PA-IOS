//
//  User.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class User {
    var idUser: Int?
    var name: String
    var firstName: String
    var profilePicture: String?
    
    init(name: String, firstName: String) {
        self.name = name
        self.firstName = firstName
    }

       var description: String {
        return "{\(self.firstName) \(self.name) \(self.profilePicture ?? "")}"
       }
}
