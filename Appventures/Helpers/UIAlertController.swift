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

    
}
