//
//  Category.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 23/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class Category : CustomStringConvertible {
    var id : Int?
    var name : String
    
    init(name: String) {
        self.name = name
    }
    
    var description: String {
        return "{\(self.id ?? 0) \(self.name)}"
    }
    
}
