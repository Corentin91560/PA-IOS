//
//  EventFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class EventFactory {
    static func eventFrom(dictionary: [String: Any]) -> Event? {
        guard let n = dictionary["name"] as? String,
              let a = dictionary["description"] as? String,
              let d = dictionary["date"] as? String,
              let l = dictionary["location"] as? String,
              let mB = dictionary["maxbenevole"] as? Int,
              let dur = dictionary["duration"] as? String else {
                return nil
        }
            
        let event = Event(name: n, apercu: a, date: dateConverter(dateMySQL: d)!, location: l, maxBenevole: mB, duration: dur)
        event.idas = dictionary["idas"] as? Int
        event.idcat = dictionary["idcat"] as? Int
        event.idev = dictionary["idev"] as? Int
        return event
        }
    
    static func dateConverter(dateMySQL: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateMySQL) as Date?
    }
}

