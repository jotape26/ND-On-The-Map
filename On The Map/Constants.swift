//
//  Constants.swift
//  On The Map
//
//  Created by João Leite on 06/01/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation

struct Constants {
    
    struct ApiURL {
        let loginURL: URL = URL(string: "https://onthemap-api.udacity.com/v1/session")!
        let studentLocationURL: URL = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        let studentInformation: String = "https://onthemap-api.udacity.com/v1/users/"
    }
    
    struct AuthKeys {
        let appId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        let restKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct HeaderFields {
        let applicationHeader: String = "X-Parse-Application-Id"
        let restKeyHeader: String = "X-Parse-REST-API-Key"
    }
    
}
