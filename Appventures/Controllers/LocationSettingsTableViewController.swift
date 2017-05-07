//
//  LocationSettingsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 01/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class LocationSettingsTableViewController: UITableViewController {
    
    struct Constants {
        static let backImage = "BackButton"
    }
    
    var step: AppventureStep!

    @IBOutlet weak var showLocation: UISwitch!
    @IBOutlet weak var showCompass: UISwitch!
    @IBOutlet weak var showDistance: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if step.setup.locationShown == true {
            showLocation.isOn = true
        }
        if step.setup.compassShown == true {
            showCompass.isOn = true
        }
        if step.setup.distanceShown == false {
            showDistance.isOn = false
        }
        
        
   }

    @IBAction func backButton(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateShowLocation(_ sender: UISwitch) {
        step.setup.locationShown = showLocation.isOn
    }
    @IBAction func updateShowCompass(_ sender: AnyObject) {
        step.setup.compassShown = showLocation.isOn
    }
    @IBAction func updateShowDistance(_ sender: UISwitch) {
        step.setup.distanceShown = showLocation.isOn
    }
    
   
}
