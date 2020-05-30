//
//  UserFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class UserFactory {
    
    static func userFrom(dictionary: [String: Any]) -> User? {
        guard let name = dictionary["name"] as? String,
              let firstname = dictionary["firstname"] as? String,
              let email = dictionary["email"] as? String,
              let password = dictionary["password"] as? String else {
                return nil
        }
        let user =  User(name: name, firstName: firstname, email: email, password: password)
        user.id = dictionary["idu"] as? Int
        return user
    }
}
