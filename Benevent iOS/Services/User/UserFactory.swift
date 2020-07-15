//
//  UserFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class UserFactory {
    
    static func userFrom(dictionary: [String: Any]) -> User? {
        guard let n = dictionary["name"] as? String,
            let fn = dictionary["firstname"] as? String else {
                    return nil
        }
        
        let user = User(name: n, firstName: fn)
        user.idUser = dictionary["iduser"] as? Int
        user.profilePicture = dictionary["profilpicture"] as? String ?? AppConfig.basicUserPictureURL
        
        return user
    }
    
}
