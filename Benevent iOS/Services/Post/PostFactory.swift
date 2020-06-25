//
//  PostFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class PostFactory {
    
    static func postFrom(dictionary: [String: Any]) -> Post? {
        guard let m = dictionary["message"] as? String,
              let d = dictionary["date"] as? String else {
                return nil
        }
        
        let post = Post(message: m, date: dateConverter(dateMySQL: d)!)
        post.idpo = dictionary["idpo"] as? Int
        post.idu = dictionary["idu"] as? Int
        post.idas = dictionary["idas"] as? Int
        post.idev = dictionary["idas"] as? Int
        return post
    }
    
    static func dateConverter(dateMySQL: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateMySQL) as Date?
    }
}
