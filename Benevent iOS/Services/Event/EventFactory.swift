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
              let dd = dictionary["dateDeb"] as? String,
              let de = dictionary["dateFin"] as? String,
              let l = dictionary["location"] as? String,
              let mB = dictionary["maxBenevole"] as? Int else {
                return nil
        }
        let event = Event(name: n, apercu: a, startDate: dateConverter(dateMySQL: dd)!, endDate: dateConverter(dateMySQL: de)!, location: l, maxBenevole: mB)
        event.idas = dictionary["idas"] as? Int
        event.idcat = dictionary["idcat"] as? Int
        event.idev = dictionary["idev"] as? Int
        return event
        }
    
    static func dictionnaryFrom(event: Event) -> [String: Any] {
           return [
            "name": event.name,
            "description": event.apercu,
            "dateDeb": mySQLFromDate(date: event.startDate),
            "dateFin": mySQLFromDate(date: event.endDate),
            "location": event.location,
            "maxBenevole": event.maxBenevole,
            "idas": event.idas!,
            "idcat": event.idcat!,
           ]
       }
    
    static func dateConverter(dateMySQL: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateMySQL) as Date?
    }
    
    static func mySQLFromDate(date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           return dateFormatter.string(from: date)
       }
}

