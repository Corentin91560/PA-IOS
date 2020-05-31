//
//  BeneventWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class BeneventWebService {
    
    func Login (mail: String, password: String, completion: @escaping ([Asso]) -> Void) -> Void {
        let assoLoginURL = AppConfig.apiURL + "/signin/association"
        let parameters: [String: Any] = [
            "email": mail,
            "password": password
        ]
        guard let apiURL = URL(string: assoLoginURL ) else {
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
                let asso = json.compactMap { (obj) -> Asso? in
                    guard let dict = obj as? [String: Any] else {
                        return nil
                    }
                    return AssoFactory.assoFrom(dictionary: dict)
                }
                DispatchQueue.main.sync {
                    completion(asso)
                }
            }
        task.resume()
    }
}

