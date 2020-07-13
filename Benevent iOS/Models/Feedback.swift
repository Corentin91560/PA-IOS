//
//  Feedback.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 12/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Feedback: CustomStringConvertible {

    var title: String?
    var content: String
    var date: Date
    var note: Int?
    var idas: Int?
    var idty: Int?
 
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
    
    
    var description: String {
        return "{\(self.content) \(self.date) \(self.note ?? 0)  \(self.idas ?? 0) \(self.idty ?? 0)}"
    }
}
