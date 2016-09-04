//
//  MapModel.swift
//  LocationTracker
//
//  Created by Nishant jethani on 9/2/16.
//  Copyright © 2016 Nishant jethani. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire


class MapModel {
    
    func getCityCoords(city: String){
        print(city)
//        let parameters = ["address": city,"apiKey" :"AIzaSyANWWEmwZ0rQoz5WEORKGU6RcPyQtnq8bY"]
        let parameters = ["address": city]

        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameters).responseJSON(options:.MutableContainers) { response in
            switch response.result {
                
            case .Failure(let error):
                print("error")
            case .Success(let value):
                
                if let json = value as? Dictionary<String,AnyObject> {
                    if let results = json["results"] as? NSArray {
                        if let result = results[0] as? Dictionary<String,AnyObject> {
                            if let geometry = result["geometry"] as? Dictionary<String,AnyObject> {
                                if let location = geometry["location"] as? Dictionary<String,AnyObject> {
                                    print(location)
                                    if let lat = location["lat"] as? Double, lng = location["lng"] as? Double {
                                        let loc = CLLocation(latitude: lat, longitude: lng)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "newLocationNotification", object: nil, userInfo: ["location" :loc]))
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
}
