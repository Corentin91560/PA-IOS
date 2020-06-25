//
//  EventWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class EventWebService {
    
    func getEvent(idEvent: Int, completion: @escaping ([Event]) -> Void) -> Void {
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
            let event = json.compactMap { (obj) -> Event? in
                guard let dict = obj as? [String: Any] else {
                    return  nil
                }
                return EventFactory.eventFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(event)
            }
        }
        task.resume()
    }
}
