//
//  Post.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Post {
    private var idPost: Int?
    private var message: String
    private var date: Date
    private var idUser: Int?
    private var idAssociation: Int?
    private var idEvent: Int?
 
    init(message: String, date: Date) {
        self.message = message
        self.date = date
    }
    
    func getIdPost() -> Int {
        return idPost!
    }
    
    func setIdPost(idPost: Int) {
        self.idPost = idPost
    }
    
    func getMessage() -> String {
        return message
    }
    
    func getDate() -> Date{
        return date
    }
    
    func getIdUser() -> Int? {
        return idUser
    }
    
    func setIdUser(idUser: Int?) {
        self.idUser = idUser
    }
    
    func getIdAssociation() -> Int? {
        return idAssociation
    }
    
    func setIdAssociation(idAssociation: Int?) {
        self.idAssociation = idAssociation
    }
    
    func getIdEvent() -> Int {
        return idEvent!
    }
    
    func setIdEvent(idEvent: Int) {
        self.idEvent = idEvent
    }
}
