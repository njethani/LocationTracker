//
//  File.swift
//  LocationTracker
//
//  Created by Nishant jethani on 9/3/16.
//  Copyright © 2016 Nishant jethani. All rights reserved.
//

import Foundation
import UIKit

protocol CityListDelegate: class {
    func onCitySelected(city : String)
}

class CityListController : UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    private var cityList : UITableView!
    private var cityNames = ["San Franscisco", "New York"]
    weak var cityListDelegate : CityListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.cityList = UITableView(frame: UIScreen.mainScreen().bounds , style: .Grouped)
        self.cityList.translatesAutoresizingMaskIntoConstraints = false
        cityList.delegate = self
        cityList.dataSource = self
        self.cityList.registerNib(UINib(nibName: "CityTableCell", bundle: nil), forCellReuseIdentifier: "cityTable")
        self.cityList.scrollEnabled = false
        self.view.addSubview(self.cityList)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftGestureHandler(_:)))
        swipeLeftGesture.direction = .Left
        self.cityList.addGestureRecognizer(swipeLeftGesture)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showLocationServicesAlert(_:)) , name: "locationManagerServicesAlert", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TableViewDelegate Methods.
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityNames.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("cityTable") as! CityTableCell
        cell.name.text = self.cityNames[row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let city = self.cityNames[row]
        cityListDelegate?.onCitySelected(city)
        self.dismissSelf()
    }
    
    //class functions
    
    func swipeLeftGestureHandler(_sender: UISwipeGestureRecognizer) {
        self.dismissSelf()
    }
    
    private func dismissSelf() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //Handling notifications
    
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