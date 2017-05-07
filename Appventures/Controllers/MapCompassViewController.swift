//
//  MapCompassViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapCompassViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var stepCoordinate = kCLLocationCoordinate2DInvalid
    lazy var showCompass = false
    lazy var showLocation = false
    lazy var showDistance = false
    lazy var locationName = ""
    
    var firstLocationUpdate = true
    var compassMarker = GMSMarker()
    var compassMarkerCircle = GMSMarker()
    var distanceMarker = GMSMarker()
    
    @IBOutlet weak var showLocationButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.isMyLocationEnabled = true
        }
    }

    
//    let compassRotateImage = UIImage(named: "White_Arrow_Up")
    let mapPointer = UIImage(named: "White_Arrow_Up50")
    let mapPointerCircel = UIImage(named: "MapPointerCircel")


    let whiteQuestionMark = UIImage(named: "whiteQuestionMark")
    
    let locationManager = CLLocationManager()
    var lastLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self

        updateLocations()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        firstLocationUpdate = true
        mapView.clear()
        if showLocation {
            addLocationMarker()
            showLocationButton.alpha = 1
        } else {
            showLocationButton.alpha = 0
        }
        self.addCompassMarker()
//        self.distanceLabel.text = "?? m"
//        self.compassImage.image? = whiteQuestionMark!


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: MapLocation
    func updateLocations() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
        if firstLocationUpdate {
            centerOnUser(self)
        }
        firstLocationUpdate = false
        if let pvc = self.parent as? StepViewController   {
            pvc.updateLastLocation(location: lastLocation)
        }
        if showDistance {_ = calculateDistanceCallParent()}
        if showCompass {compassUpdate()}
        compassMarkerCircle.position = lastLocation.coordinate
        compassMarker.position = lastLocation.coordinate
        distanceMarker.position = lastLocation.coordinate
        addDistanceTextMarker()
    }
    
    //MARK: Marker for Map
    func addLocationMarker () {
        
        let marker = GMSMarker(position: stepCoordinate)
        marker.title = locationName
        marker.map = self.mapView
    }
    

    
    func addCompassMarker () {
        compassMarkerCircle.map = self.mapView
        compassMarkerCircle.icon = self.mapPointerCircel
        compassMarkerCircle.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        compassMarkerCircle.zIndex = 1
        
        compassMarker.map = self.mapView
        compassMarker.icon = self.mapPointer
        compassMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        compassMarker.zIndex = 2
        
        
    }
    
    func addDistanceTextMarker() {
        
        if let distanceMarkerView:DistanceMarker = DistanceMarker.loadFromNibNamed("DistanceMarker")! as? DistanceMarker {
            distanceMarkerView.distanceText.text = calculateDistanceCallParent()
            distanceMarkerView.distanceText.sizeToFit()
            let markerIcon = UIImage(view: distanceMarkerView)
            distanceMarker.icon = markerIcon
            distanceMarker.map = self.mapView
            distanceMarker.zIndex = 3
            distanceMarker.groundAnchor = CGPoint(x: 0.5, y: 0)
        }
    }

    
    //MARK: Distance calculation
    func calculateDistanceCallParent() -> String {
        if let target = stepCoordinate as CLLocationCoordinate2D! {
            let lat = target.latitude
            let long = target.longitude
            let location = CLLocation(latitude: lat, longitude: long)
            let distance = location.distance(from: lastLocation)
            return HelperFunctions.formatDistance(distance)
            //            self.distanceLabel.text = ("\(HelperFunctions.formatDistance(distance))")
//            if let pvc = self.parentViewController as? StepViewController   {
//                pvc.updateLabel(distance, lastLocation: location)
//            }
        }
        
        return ""
    }
    
    //MARK: Comapass calculation
    func compassUpdate() {
//        compassImage.alpha = 1
        func degreesToRadians(_ x: Double) -> Double {
            return (M_PI * x / 180.0)
        }
        func radiansToDegrees(_ x: Double) -> Double {
            return (x * 180.0 / M_PI)
        }
        
        let fLoc = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
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
        
        _ = CGFloat(degree)
        
//        self.compassImage.image? = compassRotateImage!.imageRotatedByDegrees(floaty, flip: false)
        
    }
    
    @IBAction func centerOnUser(_ sender: AnyObject) {
        let camera = GMSCameraPosition.camera(withTarget: lastLocation.coordinate, zoom: 14)
        mapView.animate(to: camera)
    }

    @IBAction func showLocation(_ sender: AnyObject) {
        let camera = GMSCameraPosition.camera(withTarget: stepCoordinate, zoom: 14)
        mapView.animate(to: camera)
    }
}
