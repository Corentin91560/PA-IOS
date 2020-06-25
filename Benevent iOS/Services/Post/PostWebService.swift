//
//  PostWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 24/06/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class PostWebService {
    
    func getPosts(idAsso: Int, completion: @escaping ([Post]) -> Void) -> Void {
        let getPostsURL = AppConfig.apiURL + "/post/asso/\(idAsso)"
        guard let postsURL = URL(string: getPostsURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: postsURL) { (data, res, err) in
            guard let bytes = data,
            err == nil,
            let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                DispatchQueue.main.sync {
                    completion([])
                }
                return
            }
            let posts = json.compactMap { (obj) -> Post? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return PostFactory.postFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(posts)
            }
        }
        task.resume()
    }
}
