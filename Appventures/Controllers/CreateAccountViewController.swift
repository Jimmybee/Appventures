//
//  EmailLoginViewController.swift
//  Appventures
//
//  Created by James Birtwell on 17/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fadeIn()
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 1
        }) { (complete) in
            //
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 0
        }) { (complete) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
