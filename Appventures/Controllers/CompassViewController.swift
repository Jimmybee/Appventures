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
    
    let locationManager = CLLocationManager()
    var compassImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    func setupCompassController() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        
        compassImage = compass.image
    }
    
    

}

extension CompassViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.magneticHeading)
        rotateCompass(newHeading: newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
    }
}

extension CompassViewController {
    
    func rotateCompass(newHeading: CLLocationDirection){
        self.compass.image = compassImage.imageRotatedByDegrees(CGFloat(newHeading.magnitude), flip: false)
    }
    
//    func compassUpdate() {
//        //        compassImage.alpha = 1
//        func degreesToRadians(_ x: Double) -> Double {
//            return (M_PI * x / 180.0)
//        }
//        func radiansToDegrees(_ x: Double) -> Double {
//            return (x * 180.0 / M_PI)
//        }
//        
//        let fLoc = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
//        let tLoc = CLLocationCoordinate2D(latitude: stepCoordinate.latitude, longitude: stepCoordinate.longitude)
//        
//        let fLat = degreesToRadians(fLoc.latitude);
//        let fLng = degreesToRadians(fLoc.longitude);
//        let tLat = degreesToRadians(tLoc.latitude);
//        let tLng = degreesToRadians(tLoc.longitude);
//        
//        var degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
//        
//        if (degree >= 0) {
//            
//        } else {
//            degree = 360+degree
//        }
//        
//        _ = CGFloat(degree)
//        
//        //        self.compassImage.image? = compassRotateImage!.imageRotatedByDegrees(floaty, flip: false)
//        
//    }
}


