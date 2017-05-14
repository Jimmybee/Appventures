//
//  CompassViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 01/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation

class CompassViewController: UIViewController {
    
    static var nibName = "CompassViewController"

    @IBOutlet weak var compass: UIImageView!
    @IBOutlet weak var locationPointer: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var compassImage: UIImage!
    fileprivate var locationPointerImage: UIImage!
    @IBOutlet weak var crackedGlass: UIImageView!
    
    var pointerRotation = CGFloat(0)

    
    var stepCoordinate = kCLLocationCoordinate2DInvalid
    var showCompass = false
    var showDistance = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    func setupCompassController() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if showCompass {
            locationManager.startUpdatingHeading()
            crackedGlass.alpha = 0
        } else {
            crackedGlass.alpha = 1
        }
        if showDistance {
            locationManager.startUpdatingLocation()
        } else {
            distanceLabel.text = "Unknown Distance"
        }
        compassImage = compass.image
        locationPointerImage = locationPointer.image
    }
    
    func cleanup(){
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    

}

extension CompassViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        rotateCompass(newHeading: newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        rotatePointer(latestLocation: locations.last!)
        let placeCenter = CLLocation(latitude: stepCoordinate.latitude, longitude: stepCoordinate.longitude)
        distanceLabel.text = HelperFunctions.formatDistance(locations.last!.distance(from: placeCenter))
    }
}

extension CompassViewController {
    
    func rotateCompass(newHeading: CLLocationDirection){
        compass.image = compassImage.imageRotatedByDegrees(-CGFloat(newHeading), flip: false)
        locationPointer.image = locationPointerImage!.imageRotatedByDegrees(pointerRotation-CGFloat(newHeading), flip: false)
    }
    
    func rotatePointer(latestLocation: CLLocation) {
        //        compassImage.alpha = 1
        func degreesToRadians(_ x: Double) -> Double {
            return (.pi * x / 180.0)
        }
        func radiansToDegrees(_ x: Double) -> Double {
            return (x * 180.0 / .pi)
        }
        
        let fLoc = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        let tLoc = CLLocationCoordinate2D(latitude: stepCoordinate.latitude, longitude: stepCoordinate.longitude)
        
        let fLat = degreesToRadians(fLoc.latitude);
        let fLng = degreesToRadians(fLoc.longitude);
        let tLat = degreesToRadians(tLoc.latitude);
        let tLng = degreesToRadians(tLoc.longitude);
        
        var degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
        if (degree >= 0) {
            
        } else {
            degree = 360+degree
        }
        
        pointerRotation  = CGFloat(degree)
        
        
    }
    
    
}


