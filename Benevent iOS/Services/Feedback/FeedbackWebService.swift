//
//  FeedbackWebService.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 12/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation

class FeedbackWebService {
    
    func newFeedback(feedback: Feedback, completion: @escaping (Bool) -> Void) {
        let url: String!
        if(feedback.getTitle() == nil) {
            url = AppConfig.apiURL + "/feedback/rating"
        } else {
            url = AppConfig.apiURL + "/feedback/bug"
        }
        
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
}
