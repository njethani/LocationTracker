//
//  LocationManager.swift
//  LocationTracker
//
//  Created by Nishant jethani on 9/4/16.
//  Copyright © 2016 Nishant jethani. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerMapDelegate: class {
    func updateMapView(currLocation: CLLocation, marker: Bool)
    func enableLocation()
    func disableLocation()
}

var locationManager = LocationManager()

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    private var clLocationManger = CLLocationManager()
    weak var locationManagerMapDelegate: LocationManagerMapDelegate?
    var isLocationServicesEnabled = false
    
    override init() {
        super.init()
        self.clLocationManger.delegate = self
        self.clLocationManger.distanceFilter = 100
        self.clLocationManger.desiredAccuracy = kCLLocationAccuracyKilometer
        self.initLocationServicesCheck()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count != 0 {
            let currLocation = locations[0]
            self.locationManagerMapDelegate?.updateMapView(currLocation,marker: false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
        case .Restricted,.Denied :
            self.stopListeningForLocation()
        case .AuthorizedWhenInUse :
            self.startListeningForLocation()
        default:
            break
        }
        
    }
    
    func initLocationServicesCheck() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .Restricted, .Denied :
                self.sendLocationServicesAlert()
            case .NotDetermined :
                self.clLocationManger.requestWhenInUseAuthorization()
            case .AuthorizedWhenInUse :
                self.startListeningForLocation()
            default :
                break
            }
        }
        else {
           self.sendLocationServicesAlert()
        }
    }
    
    func startListeningForLocation() {
        self.isLocationServicesEnabled = true
        self.clLocationManger.startUpdatingLocation()
        self.locationManagerMapDelegate?.enableLocation()
    }
    
    func stopListeningForLocation() {
        self.isLocationServicesEnabled = false
        self.clLocationManger.stopUpdatingLocation()
        self.locationManagerMapDelegate?.disableLocation()
    }
    
    func sendLocationServicesAlert() {
         NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "locationManagerServicesAlert", object: nil ))
    }
}
