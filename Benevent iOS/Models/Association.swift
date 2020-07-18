//
//  User.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit


class Association {
    private var idAssociation: Int?
    private var name: String
    private var logo: String?
    private var acronym: String?
    private var email: String
    private var phone: String?
    private var website: String?
    private var support: String?
    private var password: String
    private var idCategory: Int?
 
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    func getIdAssociation() -> Int {
        return idAssociation!
    }
    
    func getName() -> String {
        return name
    }
    
    func setIdAssociation(idAssociation: Int) {
        self.idAssociation = idAssociation
    }
    
    func getLogo() -> String {
        return logo!
    }
    
    func setLogo(logo: String) {
        self.logo = logo
    }
    
    func getAcronym() -> String? {
        return acronym
    }
    
    func setAcronym(acronym: String?) {
        self.acronym = acronym
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getPhone() -> String? {
        return phone
    }
    
    func setPhone(phone: String?) {
        self.phone = phone
    }
    
    func getWebsite() -> String? {
        return website
    }
    
    func setWebsite(website: String?) {
        self.website = website
    }
    
    func getSupport() -> String? {
        return support
    }
    
    func setSupport(support: String?) {
        self.support = support
    }
    
    func getIdCategory() -> Int {
        return idCategory!
    }
    func setIdCategory(idCategory: Int) {
        self.idCategory = idCategory
    }
}
