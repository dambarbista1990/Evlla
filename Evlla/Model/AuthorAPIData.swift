//
//  AuthorData.swift
//  Evllaz
//
//  Created by Dambar Bista on 4/8/20.
//  Copyright © 2020 Dambar Bista. All rights reserved.
//

import Foundation

 // struct for API
// storing the JSON data from third party to convert into native swift

struct AuthorAPIData: Codable {
    
    var message: String
    var author: String
    
}


