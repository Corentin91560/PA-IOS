//
//  Event.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Event{
    
    private var idEvent: Int?
    private var name: String
    private var apercu: String
    private var startDate: Date
    private var endDate: Date
    private var location: String
    private var maxBenevole: Int
    private var fakeEvent: Bool
    private var idCategory: Int?
    private var idAssociation: Int?
    
    init(name: String, apercu: String, startDate: Date, endDate: Date, location: String, maxBenevole: Int, fakeEvent: Bool) {
        self.name = name
        self.apercu = apercu
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.maxBenevole = maxBenevole
        self.fakeEvent = fakeEvent
    }
    
    func isInProgress() -> Bool {
        let now = Date().now()
        return startDate < now && endDate > now ? true : false
    }
    
    func getIdEvent() -> Int {
        return idEvent!
    }
    
    func setIdEvent(idEvent: Int) {
        self.idEvent = idEvent
    }
    
    func getName() -> String {
        return name
    }
    
    func getApercu() -> String {
        return apercu
    }
    
    func getStartDate() -> Date {
        return startDate
    }
    
    func getEndDate() -> Date {
        return endDate
    }
    
    func getLocation() -> String {
        return location
    }
    
    func getMaxBenevole() -> Int {
        return maxBenevole
    }
    
    func getFakeEvent() -> Bool {
        return fakeEvent
    }
    
    func getIdCategory() -> Int {
        return idCategory!
    }
    
    func setIdCategory(idCategory: Int) {
        self.idCategory = idCategory
    }
    
    func getIdAssociation() -> Int {
        return idAssociation!
    }
    
    func setIdAssociation(idAssociation: Int) {
        self.idAssociation = idAssociation
    }
}
