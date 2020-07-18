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
        post.setIdPost(idPost: dictionary["idpost"] as! Int)
        post.setIdUser(idUser: dictionary["iduser"] as? Int)
        post.setIdAssociation(idAssociation: dictionary["idassociation"] as? Int)
        post.setIdEvent(idEvent: dictionary["idevent"] as! Int)
        return post
    }
    
    static func dictionnaryFrom(post: Post) -> [String: Any] {
        return [
            "message": post.getMessage(),
            "date": mySQLFromDate(date: post.getDate()),
            "idassociation": post.getIdAssociation()!,
            "idevent": post.getIdEvent()
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

