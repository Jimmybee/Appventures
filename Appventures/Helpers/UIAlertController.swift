//
//  UIAlertController.swift
//  EA - Clues
//
//  Created by James Birtwell on 26/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    class func showAlertToast(_ message: String, length: Double = 1.0) {
        let alertToast = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertToast, animated: true, completion: nil)
        DispatchQueue.main.async { () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(length * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                alertToast.dismiss(animated: true, completion: nil)
            })
        }
    }

    class func createDirectionsAlert(coordinate: CLLocationCoordinate2D, name: String?) -> UIAlertController {
        let alert = UIAlertController(title: "Directions", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if UIApplication.shared.canOpenURL(NSURL(string:"citymapper://")! as URL) {
            alert.addAction(UIAlertAction(title: "City Mapper", style: .default, handler: { action in
                let urlString = "citymapper://directions?endcoord=\(coordinate.latitude),\(coordinate.longitude)"
                UIApplication.shared.open(URL(string: urlString)!)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { action in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }))
        
        
        if UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { action in
                UIApplication.shared.open(URL(string:
                    "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
            }))
        }
        
        return alert
    }
    
}
