//
//  ProfileHeaderViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ProfileHeaderViewController: UIViewController {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var circledImageView: UIImageView!
    
//    @IBOutlet weak var fbConnect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func updateCircleImage() {
//        fbConnect.alpha = 0
        HelperFunctions.circle(circledImageView)
        self.loadSpinner.stopAnimating()
    }
    
    func setFbConnectBttn() {
//        fbConnect.alpha = 1
        
        self.loadSpinner.stopAnimating()
    }

 
}
