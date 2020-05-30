//
//  BeneventWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class BeneventWebService {
    
    func Login (mail: String, password: String, completion: @escaping ([User]) -> Void) -> Void {
        let userLoginURL = AppConfig.apiURL + "/signin/user"
        let parameters: [String: Any] = [
            "email": mail,
            "password": password
        ]
        
        guard let apiURL = URL(string: userLoginURL ) else {
            return;
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
         guard let bytes = data,
                      err == nil,
                      let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                        DispatchQueue.main.sync {
                            completion([])
                        }
                    return
                }
            print(json)
                let user = json.compactMap { (obj) -> User? in
                    guard let dict = obj as? [String: Any] else {
                        return nil
                    }
                    return UserFactory.userFrom(dictionary: dict)
                }
                DispatchQueue.main.sync {
                    completion(user)
                }
            }
        task.resume()
    }
}

