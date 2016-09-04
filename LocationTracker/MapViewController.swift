//
//  ViewController.swift
//  LocationTracker
//
//  Created by Nishant jethani on 9/2/16.
//  Copyright © 2016 Nishant jethani. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController,CityListDelegate,GMSMapViewDelegate,LocationManagerMapDelegate {
    private var clLocationManger = CLLocationManager()
    private var mapModel = MapModel()

    @IBOutlet private var mapView: GMSMapView!

    @IBAction private func onMenuButtonClicked(sender: UIButton){
      
        print("menu button")
        self.presentCityList()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        self.mapView.settings.myLocationButton = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNewLocationHandler(_:)) , name: "newLocationNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showLocationServicesAlert(_:)) , name: "locationManagerServicesAlert", object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func presentCityList() {
        let cityListController = CityListController()
        cityListController.cityListDelegate = self
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.presentViewController(cityListController, animated: false, completion: nil)
    }
    
    //Location Manager Map Delegate functions
    
    func enableLocation() {
        self.mapView.settings.myLocationButton = true
        self.mapView.myLocationEnabled = true
    }
    
    func disableLocation() {
        self.mapView.myLocationEnabled = false
    }
    
    func updateMapView(location: CLLocation,marker: Bool) {
        
        let position = location.coordinate
        let camera = GMSCameraPosition.cameraWithLatitude(position.latitude, longitude: position.longitude, zoom: 12)
        self.mapView.animateToCameraPosition(camera)
        if marker {
            let marker = GMSMarker(position: position)
            marker.appearAnimation = kGMSMarkerAnimationPop
            self.mapView.clear()
            marker.map = self.mapView
        }
        
    }
    
    //GMSMapViewDelegate
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        if locationManager.isLocationServicesEnabled {
            return false
        }
        locationManager.initLocationServicesCheck()
        return true
    }
    
    // On city selected in the City list controller Delegate
    
    func onCitySelected(city: String) {
        self.mapModel.getCityCoords(city)
    }

    
    //Handling Notifications
    
    func onNewLocationHandler(notification : NSNotification) {
        if let userInfo = notification.userInfo as? Dictionary<String,CLLocation> {
            let location = userInfo["location"]
            self.updateMapView(location!,marker: true)
        }
    }
    
    //Location Services disabled alert to change settings.
    func showLocationServicesAlert(notification: NSNotification) {
        print("location services disabled")
        
        let alertController = UIAlertController(title: "Location Services Disabled", message: "Location Tracker needs access to your location. Please turn on Location Services in your device settings.", preferredStyle: .Alert )
        let cancelAction = UIAlertAction(title: "NO THANKS", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "CHANGE SETTINGS", style: .Default) { (action:UIAlertAction!) in
            alertController.dismissViewControllerAnimated(false, completion: nil)
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(OKAction)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }

    
    
}

