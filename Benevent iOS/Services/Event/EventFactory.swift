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
              let dd = dictionary["startdate"] as? String,
              let de = dictionary["enddate"] as? String,
              let l = dictionary["location"] as? String,
              let mB = dictionary["maxbenevole"] as? Int,
              let fe = dictionary["fakeevent"] as? Bool else {
                return nil
        }
        let event = Event(name: n, apercu: a, startDate: dateConverter(dateMySQL: dd)!, endDate: dateConverter(dateMySQL: de)!, location: l, maxBenevole: mB, fakeEvent: fe)
        event.setIdAssociation(idAssociation: dictionary["idassociation"] as! Int)
        event.setIdCategory(idCategory: dictionary["idcategory"] as! Int)
        event.setIdEvent(idEvent: dictionary["idevent"] as! Int)
        return event
        }
    
    static func dictionnaryFrom(event: Event) -> [String: Any] {
            
           return [
            "name": event.getName(),
            "description": event.getApercu(),
            "startdate": mySQLFromDate(date: event.getStartDate()),
            "enddate": mySQLFromDate(date: event.getEndDate()),
            "location": event.getLocation(),
            "maxbenevole": event.getMaxBenevole(),
            "idcategory": event.getIdCategory(),
            "idassociation": event.getIdAssociation()
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

