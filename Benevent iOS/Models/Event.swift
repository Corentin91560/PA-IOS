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
    var date: Date
    var location: String
    var maxBenevole: Int
    var duration: String
    var idcat: Int?
    var idas: Int?
    
    init(name: String, apercu: String, date: Date, location: String, maxBenevole: Int, duration: String) {
        self.name = name
        self.apercu = apercu
        self.date = date
        self.location = location
        self.maxBenevole = maxBenevole
        self.duration = duration
    }
       
       
       var description: String {
        return "{\(self.idev ?? 0) \(self.name) \(self.apercu) \(self.date)  \(self.location) \(self.maxBenevole) \(self.duration) \(self.idcat ?? 0) \(self.idas ?? 0)}"
       }
    
}
