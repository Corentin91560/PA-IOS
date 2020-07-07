//
//  Category.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

import Foundation

class Category: CustomStringConvertible {

    var idcat: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }

    var description: String {
        return "{Catégorie \(self.idcat!) : \(self.name)}"
    }
}
