//
//  CategoryFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 23/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class CategoryFactory {
    
    
    static func categoryFrom(dictionary: [String: Any]) -> Category? {
        guard let name = dictionary["name"] as? String else {
                return nil
        }
        
        let cat =  Category(name: name)
        cat.id = dictionary["id"] as? Int
        return cat
    }
}
