//
//  ProfileWrapperViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ProfileWrapperViewController: UIViewController {

    @IBOutlet weak var containerForUser: UIView!
    
    var embeddedSettings: SettingsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerForUser.alpha = 1
        // Do any additional setup after loading the view.
    }
    
    
    func showForUser() {
        containerForUser.alpha = 1
        embeddedSettings.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Get container view controllers 

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SettingsTableViewController {
            self.embeddedSettings = vc
        }
    }

}
