//
//  Pin.swift
//  BI-IOS
//
//  Created by Karolina Solanska on 28/12/2017.
//  Copyright © 2017 ČVUT. All rights reserved.
//

import Foundation

// { "gender": "male", "lat": 70, "lon": 70, "time": 1232.123, "username": "Potato2" }

struct Pin : Decodable {
    var gender : String
    var lat : Double
    var lon : Double
    var time : Double
    var username: String
}

