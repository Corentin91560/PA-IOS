//
//  CategoryFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class CategoryFactory {
    
    static func categoryFrom(dictionary: [String: Any]) -> Category? {
        guard let n = dictionary["name"] as? String else {
                return nil
        }
        
        let category = Category(name: n)
        category.idCategory = dictionary["idcategory"] as? Int
        
        return category
    }
}
