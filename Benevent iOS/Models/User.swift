//
//  User.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit


class User: CustomStringConvertible {
    var id: Int?
    var name: String
    var firstName: String
    var age: Date?
    var email: String
    var password: String
    var phone: String?
    var profilpicture: UIImage?
    var address: String?
    var bio: String?
        
    init(name: String, firstName: String, email: String, password: String) {
        self.name = name
        self.firstName = firstName
        self.email = email
        self.password = password
    }
    
    
    var description: String {
        return "{\(self.id ?? 0) \(self.name) \(self.firstName) \(self.age ?? Date()) \(self.email) \(self.password) \(self.phone ?? "") \(self.address ?? "") \(self.bio ?? "")}"
    }
}
