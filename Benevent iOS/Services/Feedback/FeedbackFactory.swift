//
//  FeedbackFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 12/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class FeedbackFactory {
    
    static func dictionnaryFrom(feedback: Feedback) -> [String: Any] {
        return [
            "content": feedback.getContent(),
            "date": mySQLFromDate(date: feedback.getDate()),
            "note": feedback.getNote() ?? 0,
            "title": feedback.getTitle() ?? "",
            "platform": "IOS",
            "idtype": feedback.getIdType(),
            "idassociation": feedback.getIdAssociation()    
        ]
    }
    
    static func mySQLFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

