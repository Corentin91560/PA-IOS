//
//  UserFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class AssoFactory {
    
    static func assoFrom(dictionary: [String: Any]) -> Asso? {
        guard let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String,
              let password = dictionary["password"] as? String else {
                return nil
        }
        let asso =  Asso(name: name, email: email, password: password)
        asso.idas = dictionary["idas"] as? Int
        asso.idcat = dictionary["idcat"] as? Int
        return asso
    }
}
