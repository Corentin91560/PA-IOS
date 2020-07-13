//
//  FeedbackWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 12/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class FeedbackWebService {
    
    func newBug(feedback: Feedback, completion: @escaping (Bool) -> Void) -> Void {
        let url = AppConfig.apiURL + "/feedback/bug"
        guard let newPostURL = URL(string: url) else {
            return
        }
        var request = URLRequest(url: newPostURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: FeedbackFactory.dictionnaryFrom(feedback: feedback), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 200)
            }
            completion(false)
        })
        task.resume()
    }
    
    func newEvaluation(feedback: Feedback, completion: @escaping (Bool) -> Void) -> Void {
           let url = AppConfig.apiURL + "/feedback/evaluation"
           guard let newPostURL = URL(string: url) else {
               return
           }
           var request = URLRequest(url: newPostURL)
           request.httpMethod = "POST"
           request.httpBody = try? JSONSerialization.data(withJSONObject: FeedbackFactory.dictionnaryFrom(feedback: feedback), options: .fragmentsAllowed)
        print("EVAL HTTP BODY: \(FeedbackFactory.dictionnaryFrom(feedback: feedback))")
           request.setValue("application/json", forHTTPHeaderField: "content-type")
           let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
               if let httpRes = res as? HTTPURLResponse {
                   completion(httpRes.statusCode == 200)
               }
               completion(false)
           })
           task.resume()
       }
}
