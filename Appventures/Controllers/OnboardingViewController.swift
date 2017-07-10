//
//  OnboardingViewController.swift
//  Appventures
//
//  Created by James Birtwell on 10/07/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class OnboardingViewController: BaseViewController {
    
    static let storyboardId = "OnboardingViewController"
    
    static func storyboardInit() -> OnboardingViewController {
        return UIStoryboard.mainViewControllerWith(id: storyboardId) as! OnboardingViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    
}
