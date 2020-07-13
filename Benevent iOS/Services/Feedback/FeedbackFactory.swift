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
            "content": feedback.content,
            "date": mySQLFromDate(date: feedback.date),
            "note": feedback.note ?? 0,
            "title": feedback.title ?? "",
            "plateform": "IOS",
            "idty": feedback.idty!,
            "idas": feedback.idas!
        ]
    }
    
    static func mySQLFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

