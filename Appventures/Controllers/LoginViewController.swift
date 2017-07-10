//
//  LoginViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AVKit
import AVFoundation

var centralDispatchGroup = DispatchGroup()

class LoginViewController: BaseViewController, PresentingViewController {
    
    var player: AVPlayer?
    
    @IBOutlet weak var logInBttn: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    
    var user = BackendlessUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let onboarding = OnboardingViewController.storyboardInit()
        self.present(onboarding, animated: false, completion: nil)
        UIView.animate(withDuration: 0.4, animations: {
            self.logInBttn.alpha = 1
            self.mainStackView.alpha = 1
        }) { (complete) in

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.logInBttn.alpha = 0
            self.mainStackView.alpha = 0
        }) { (complete) in
            self.performSegue(withIdentifier: "LogIn", sender: self)
        }
    }

    @IBAction func registerTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.logInBttn.alpha = 0
            self.mainStackView.alpha = 0
        }) { (complete) in
            self.performSegue(withIdentifier: "CreateAccount", sender: self)
        }
    
    }

    @IBAction func facebookLogin(_ sender: UIButton) {
        centralDispatchGroup.enter()
        UserManager.loginWithFacebookSDK(viewController: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let elvc = segue.destination as? EmailLoginViewController {
            elvc.delegate = self
        }
        if let cavc = segue.destination as? CreateAccountViewController {
            cavc.delegate = self
        }
    }
   
}

