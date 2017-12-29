//
//  DataManager.swift
//  BI-IOS
//
//  Created by Dominik Vesely on 06/11/2017.
//  Copyright © 2017 ČVUT. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import CoreLocation

class DataManager {
    
    func getPins( callback: @escaping (([AnyObject]) -> ()))  {
        
        Alamofire.request("https://bi-ios-task-2.firebaseio.com/checkins.json").responseJSON { response in
            if let data = response.data {
                var jsonResponse : Dictionary<String, AnyObject>?
                do{
                    var pins = [AnyObject]()
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject>
                    for (key, value) in jsonResponse! {
                        print(key, value)
                        pins.append(value);
                    }
                    callback(pins)
                } catch  {
                     print("Error deserializing JSON: \(error)")
                }
            }
        }
    }
    
    func addPin(username: String, gender: String, lat: Double, lon: Double, callback: (String) -> ()) {
        
        let parameters: [String: AnyObject] = [
            "gender" : gender as AnyObject,
            "username" : username as AnyObject,
            "lat" : lat as AnyObject,
            "lon": lon as AnyObject,
            "time": Date().millisecondsSince1970 as AnyObject,
        ]
        
        Alamofire.request("https://bi-ios-task-2.firebaseio.com/checkins.json", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

