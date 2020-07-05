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
        
        let post = Post(message: m, date: dateFromMySQL(dateMySQL: d)!)
        post.idpo = dictionary["idpo"] as? Int
        post.idu = dictionary["idu"] as? Int
        post.idas = dictionary["idas"] as? Int
        post.idev = dictionary["idev"] as? Int
        return post
    }
    
    static func dictionnaryFrom(post: Post) -> [String: Any] {
        return [
            "message": post.message,
            "date": mySQLFromDate(date: post.date),
            "idas": post.idas!,
            "idev": post.idev!
        ]
    }
    
    static func dateFromMySQL(dateMySQL: String) -> Date? {
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

