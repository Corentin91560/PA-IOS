//
//  User.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class User {
    private var idUser: Int?
    private var name: String
    private var firstname: String
    private var profilePicture: String?
    
    init(name: String, firstName: String) {
        self.name = name
        self.firstname = firstName
    }
    
    func getIdUser() -> Int {
        return idUser!
    }
    
    func setIdUser(idUser: Int) {
        self.idUser = idUser
    }
    
    func getName() -> String {
        return name
    }
    
    func getFirstname() -> String {
        return firstname
    }
    
    func getProfilePicture() -> String {
        return profilePicture!
    }
    
    func setProfilePicture(profilePicture: String) {
        self.profilePicture = profilePicture
    }
}
