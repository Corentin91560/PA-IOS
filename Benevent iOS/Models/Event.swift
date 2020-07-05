//
//  Event.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Event : CustomStringConvertible {
    
    var idev: Int?
    var name: String
    var apercu: String
    var startDate: Date
    var endDate: Date
    var location: String
    var maxBenevole: Int
    var idcat: Int?
    var idas: Int?
    
    init(name: String, apercu: String, startDate: Date, endDate: Date, location: String, maxBenevole: Int) {
        self.name = name
        self.apercu = apercu
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.maxBenevole = maxBenevole
    }
       
       
       var description: String {
        return "{\(self.idev ?? 0) \(self.name) \(self.apercu) \(self.startDate) \(self.endDate)  \(self.location) \(self.maxBenevole) \(self.idcat ?? 0) \(self.idas ?? 0)}"
       }
    
}
