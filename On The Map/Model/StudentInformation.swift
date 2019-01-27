//
//  StudentInformation.swift
//  On The Map
//
//  Created by João Leite on 27/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation

struct StudentInformation{

    let objectId: String?
    let lastName: String?
    let mapString: String?
    let longitude: Double?
    let firstName: String?
    let mediaURL: String?
    let uniqueKey: String?
    let latitude: Double?
    let createdAt: String?
    let updatedAt: String?
    
    init(_ dic: [String: AnyObject]){
        objectId = dic["objectId"] as? String
        lastName = dic["lastName"] as? String
        mapString = dic["mapString"] as? String
        longitude = dic["longitude"] as? Double
        firstName = dic["firstName"] as? String
        mediaURL = dic["mediaURL"] as? String
        uniqueKey = dic["uniqueKey"] as? String
        latitude = dic["latitude"] as? Double
        createdAt = dic["createdAt"] as? String
        updatedAt = dic["updatedAt"] as? String
    }
    
    static func pinsFromResults(_ results: NSArray) -> [StudentInformation]{
        var pins: [StudentInformation] = []
        for r in results {
            pins.append(StudentInformation(r as! [String: AnyObject]))
        }
        return pins
    }
}
