//
//  ViewController.swift
//  SwiftySpeedometer
//
//  Created by Gary Sapozhnikov on 7/9/17.
//  Copyright © 2017 Gary Sapozhnikov. All rights reserved.
//

import UIKit
import CoreLocation

typealias Speed = CLLocationSpeed

protocol SwiftySpeedDelegate {
    func speedDidChange(_ speed: Speed)
}

class SwiftySpeedManager : NSObject, CLLocationManagerDelegate {
    var delegate : SwiftySpeedDelegate?
    fileprivate let locationManager : CLLocationManager?
    
    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil
        
        super.init()
        
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestAlwaysAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0);
            delegate?.speedDidChange(kmph);
        }
    }
}


class ViewController: UIViewController, SwiftySpeedDelegate {

    let speedManager = SwiftySpeedManager()
    
    var speedTicker = UILabel()
    
    override func viewDidLoad() {
        speedManager.delegate = self
        super.viewDidLoad()
        
        speedTicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        speedTicker.numberOfLines = 2
        speedTicker.textAlignment = .center
        speedTicker.adjustsFontSizeToFitWidth = true
        speedTicker.font = UIFont.systemFont(ofSize: 120.0, weight: 0.2)
        view.addSubview(speedTicker)
        
    }
    
    func speedDidChange(_ speed: Speed) {
        speedTicker.text = "\(String(Int(speed))) \nkmh"
    }

}

