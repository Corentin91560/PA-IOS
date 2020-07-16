//
//  UserWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class UserWebService {
    
    
    func getUserById(idUser: Int, completion: @escaping ([User]) -> Void) {
        let getUserURL = AppConfig.apiURL + "/user/\(idUser)"
        guard let userURL = URL(string: getUserURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: userURL) { (data, res, err) in
            guard let bytes = data,
                err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                    return
                }
            let users = json.compactMap { (obj) -> User? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return UserFactory.userFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(users)
            }
        }
        task.resume()
    }
    
    func getUsersByIdAsso(idAsso: Int, completion: @escaping ([User]) -> Void) -> Void {
           let getUserURL = AppConfig.apiURL + "/users/association/\(idAsso)"
           guard let userURL = URL(string: getUserURL) else {
               return
           }
           let task = URLSession.shared.dataTask(with: userURL) { (data, res, err) in
               guard let bytes = data,
                   err == nil,
                   let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                       DispatchQueue.main.sync {
                           completion([])
                       }
                       return
                   }
               let users = json.compactMap { (obj) -> User? in
                   guard let dict = obj as? [String: Any] else {
                       return nil
                   }
                   return UserFactory.userFrom(dictionary: dict)
               }
               DispatchQueue.main.sync {
                   completion(users)
               }
           }
           task.resume()
       }
    
    func getUsersByIdEvent(idEvent: Int, completion: @escaping ([User]) -> Void) {
        let getUserURL = AppConfig.apiURL + "/participants/\(idEvent)"
        guard let userURL = URL(string: getUserURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: userURL) { (data, res, err) in
            guard let bytes = data,
                err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                    return
                }
            let users = json.compactMap { (obj) -> User? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return UserFactory.userFrom(dictionary: dict)
            }
            DispatchQueue.main.sync {
                completion(users)
            }
        }
        task.resume()
    }
}
