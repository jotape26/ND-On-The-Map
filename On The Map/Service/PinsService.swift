//
//  PinsService.swift
//  On The Map
//
//  Created by João Leite on 27/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation

class PinsService {
    
    func getStudentPins(success: @escaping([String: AnyObject])->(),
                        failure: @escaping(Error)->()){
        var request = URLRequest(url: Constants.ApiURL().studentLocationURL)
        request.addValue(Constants.AuthKeys().appId, forHTTPHeaderField: Constants.HeaderFields().applicationHeader)
        request.addValue(Constants.AuthKeys().restKey, forHTTPHeaderField: Constants.HeaderFields().restKeyHeader)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, res, err in
            
            if err != nil {
                failure(err!)
            }
            
            let parsedData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
            
            success(parsedData)
        }
        task.resume()
    }
    
    func postNewPin(params : StudentInformation,
                    success: @escaping([String: AnyObject])->(),
                    failure: @escaping(Error)->()){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.AuthKeys().appId, forHTTPHeaderField: Constants.HeaderFields().applicationHeader)
        request.addValue(Constants.AuthKeys().restKey, forHTTPHeaderField: Constants.HeaderFields().restKeyHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(params.uniqueKey!)\", \"firstName\": \"\(params.firstName!)\", \"lastName\": \"\(params.lastName!)\",\"mapString\": \"\(params.mapString!)\", \"mediaURL\": \"\(params.mediaURL!)\",\"latitude\": \(params.latitude!), \"longitude\": \(params.longitude!)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, res, err in
            if err != nil { // Handle error…
                failure(err!)
            }
            
            let parsedData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
            
            if parsedData["createdAt"] != nil {
                success(parsedData)
            }
        }
        task.resume()
        
    }
}
