//
//  CategoryWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 23/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class CategoryWebService {
    
    func getCategories (completion: @escaping ([Category]) -> Void) -> Void {
        let getCategoriesURL = AppConfig.apiURL + "/category"
        guard let apiURL = URL(string: getCategoriesURL ) else {
            return;
        }
        let task = URLSession.shared.dataTask(with: apiURL) { (data, res, err) in
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
                        return nil
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

