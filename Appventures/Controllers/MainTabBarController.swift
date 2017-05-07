//
//  MainTabBarController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import FBSDKCoreKit


let statupDispatchGroup = DispatchGroup()

class MainTabBarController: UITabBarController {
    
    struct StoryboardNames {
        static let startupLogin = "startupLogin"
    }

    let backendless = Backendless.sharedInstance()

    var stdFrame: CGRect?
    var nilMe: String!
    
    override func viewDidLoad() {
        
//        self.tabBar.tintColor = UIColor.redColor()
        //MARK: CheckUser
        self.selectedIndex = 2
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func showUserSettings() {
        for (index, controller) in self.viewControllers!.enumerated() {
            if let nvc = controller as? UINavigationController  {
                print("\(index) for \(nvc.viewControllers.first)")
            }
        }
        if let nvc = self.viewControllers?[1] as? UINavigationController,
            let pwvc = nvc.viewControllers.first as? ProfileWrapperViewController {
//            pwvc.showForUser()
        }
    }

    
}
