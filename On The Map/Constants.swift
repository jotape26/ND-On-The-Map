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
    }
    
}
