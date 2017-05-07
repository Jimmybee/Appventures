//
//  AnnotatedScreenshotViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 13/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class AnnotatedScreenshotViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
