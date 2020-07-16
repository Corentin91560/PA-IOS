//
//  EventWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class EventWebService {
    
    func getEvent(idEvent: Int, completion: @escaping ([Event]) -> Void) {
        let getEventURL = AppConfig.apiURL + "/event/\(idEvent)"
        guard let eventURL = URL(string: getEventURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: eventURL) { (data, res, err) in
            guard let bytes = data,
            err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            let events = json.compactMap { (obj) -> Event? in
                guard let dict = obj as? [String: Any] else {
                    return  nil
                }
                return EventFactory.eventFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(events)
            }
        }
        task.resume()
    }
    
    func getEventsByAssociation(idAsso: Int, completion: @escaping ([Event]) -> Void) {
          let getEventURL = AppConfig.apiURL + "/events/association/\(idAsso)"
             guard let eventURL = URL(string: getEventURL) else {
                 return
             }
             let task = URLSession.shared.dataTask(with: eventURL) { (data, res, err) in
                 guard let bytes = data,
                 err == nil,
                     let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                         DispatchQueue.main.sync {
                             completion([])
                         }
                     return
                 }
                 let events = json.compactMap { (obj) -> Event? in
                     guard let dict = obj as? [String: Any] else {
                         return  nil
                     }
                     return EventFactory.eventFrom(dictionary: dict)
                 }
                 DispatchQueue.main.sync {
                     completion(events)
                 }
             }
             task.resume()
    }
    
    func newEvent(event: Event, completion: @escaping (Bool) -> Void) {
        let url = AppConfig.apiURL + "/event"
        guard let newEventURL = URL(string: url) else {
            return
        }
        var request = URLRequest(url: newEventURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: EventFactory.dictionnaryFrom(event: event), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 200)
            }
            completion(false)
        })
        task.resume()
    }
    
    func updateEvent(event: Event, completion: @escaping (Bool) -> Void) {
        let url = AppConfig.apiURL + "/event/\(event.idEvent!)"
        guard let updateEventURL = URL(string: url) else {
            return
        }
           
        var request = URLRequest(url: updateEventURL)
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: EventFactory.dictionnaryFrom(event: event), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 200)
            }
            completion(false)
        })
        task.resume()
    }
    
    func deleteEvent(idEvent: Int, completion: @escaping (Bool) -> Void) {
        guard let deleteEventURL = URL(string: AppConfig.apiURL + "/event/\(idEvent)") else {
              return;
        }
        var request = URLRequest(url: deleteEventURL)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 204)
                return
            }
            completion(false)
        })
        task.resume()
    }
}
