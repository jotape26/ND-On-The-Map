//
//  UserService.swift
//  On The Map
//
//  Created by João Leite on 27/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation

class UserService{
    
    func userLogin(email: String,
                   password: String,
                   success: @escaping ([String: AnyObject])->(),
                   failure: @escaping (Error)->()){
        var request = URLRequest(url: Constants.ApiURL.init().loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, res, err) in
            if err != nil {
                failure(err!)
                return
            }
            
            let parsedData = try! JSONSerialization.jsonObject(with: data!.subdata(in: 5..<data!.count), options: .allowFragments) as! [String : AnyObject]
            
            success(parsedData)
        }
        task.resume()
    }
    
    func getUserDetails(key: String,
                        success: @escaping([String: AnyObject])->(),
                        failure: @escaping(Error)->()){
        
        let request = URLRequest(url: URL(string: Constants.ApiURL().studentInformation + key)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, res, err in
            if err != nil {
                failure(err!)
                return
            }
            let parsedData = try! JSONSerialization.jsonObject(with: data!.subdata(in: 5..<data!.count), options: .allowFragments) as! [String : AnyObject]
            success(parsedData)
        }
        task.resume()
    }
    
}
