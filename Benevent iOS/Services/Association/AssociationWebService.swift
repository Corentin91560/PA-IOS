//
//  AssociationWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation


class AssociationWebService {
    
    func Login (mail: String, password: String, completion: @escaping ([Association]) -> Void) -> Void {
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
                let asso = json.compactMap { (obj) -> Association? in
                    guard let dict = obj as? [String: Any] else {
                        return nil
                    }
                    return AssociationFactory.associationFrom(dictionary: dict)
                }
                DispatchQueue.main.sync {
                    completion(asso)
                }
            }
        task.resume()
    }
    
    func Signup(name: String, email: String, password: String, profilePicture: String, idCategory: Int, completion: @escaping (Bool) -> Void) -> Void {
        
        let assoLoginURL = AppConfig.apiURL + "/signup/association"
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "logo": profilePicture,
            "idcat": idCategory
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
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 201)
            }
            completion(false)
        }
        task.resume()
    }
    
    func getAssociationById(idAsso: Int, completion: @escaping ([Association]) -> Void) -> Void {
          let getAssociationURL = AppConfig.apiURL + "/association/\(idAsso)"
          guard let assoURL = URL(string: getAssociationURL) else {
              return
          }
          let task = URLSession.shared.dataTask(with: assoURL) { (data, res, err) in
              guard let bytes = data,
              err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                      DispatchQueue.main.sync {
                          completion([])
                      }
                  return
              }
              let asso = json.compactMap { (obj) -> Association? in
                  guard let dict = obj as? [String: Any] else {
                      return  nil
                  }
                return AssociationFactory.associationFrom(dictionary: dict)
              }
              DispatchQueue.main.sync {
                  completion(asso)
              }
          }
          task.resume()
      }
    
    func updateAsso(asso: Association, completion: @escaping (Bool) -> Void) -> Void {
        let url = AppConfig.apiURL + "/association/\(asso.idas!)"
        guard let updateAssoURL = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: updateAssoURL)
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: AssociationFactory.dictionnaryFrom(asso: asso), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 200)
            }
            completion(false)
        })
        task.resume()
    }
    
    func deleteAsso(idAsso: Int, completion: @escaping (Bool) -> Void) -> Void {
           guard let deleteAssoURL = URL(string: AppConfig.apiURL + "/association/\(idAsso)") else {
                 return;
           }
           var request = URLRequest(url: deleteAssoURL)
           request.httpMethod = "DELETE"
           let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
               if let httpRes = res as? HTTPURLResponse {
                   completion(httpRes.statusCode == 204)
                   return
               }
               completion(false)
           })
           task.resume()
       }
}

