//
//  Feedback.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 12/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Feedback {
    private var title: String?
    private var content: String
    private var date: Date
    private var note: Int?
    private var idAssociation: Int?
    private var idType: Int?
 
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func getContent() -> String {
        return content
    }
    
    func getDate() -> Date {
        return date
    }
    
    func getNote() -> Int? {
        return note
    }
    
    func setNote(note: Int) {
        self.note = note
    }
    
    func getIdAssociation() -> Int {
        return idAssociation!
    }
    
    func setIdAssociation(idAssociation: Int) {
        self.idAssociation = idAssociation
    }
    
    func getIdType() -> Int {
        return idType!
    }
    
    func setIdType(idType: Int) {
        self.idType = idType
    }
}
