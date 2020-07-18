//
//  Category.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

import Foundation

class Category {

    private var idCategory: Int?
    private var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getIdCategory() -> Int {
        return idCategory!
    }
    
    func setIdCategory(idCategory: Int) {
        self.idCategory = idCategory
    }
    
    func getName() -> String {
        return name
    }

}
