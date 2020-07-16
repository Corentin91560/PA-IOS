//
//  CategoryWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 06/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class CategoryWebService {
    
    func getCategories(completion: @escaping ([Category]) -> Void) {
        let getCategoriesURL = AppConfig.apiURL + "/categories"
        
        guard let categoriesURL = URL(string: getCategoriesURL) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: categoriesURL) { (data, res, err) in
            guard let bytes = data,
            err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            let categories = json.compactMap { (obj) -> Category? in
                guard let dict = obj as? [String: Any] else {
                    return  nil
                }
                return CategoryFactory.categoryFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(categories)
            }
        }
        task.resume()
    }
}
