//
//  UIStoryboard.swift
//  easySwitch
//
//  Created by James Birtwell on 31/05/2017.
//  Copyright © 2017 Warmup. All rights reserved.
//

import Foundation

extension UIStoryboard {
    
    static func mainViewControllerWith(id: String) -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: id)
    }
    
}
