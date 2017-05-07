//
//  UserSignInViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4

class UserSignInViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    weak var parentContainer: ProfileWrapperViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsCenter = NotificationCenter.default
//        nsCenter.addObserver(self, selector:  #selector(UserSignInViewController.failedSingup), name: NSNotification.Name(rawValue: User.failedParseSignup), object: nil)
//        nsCenter.addObserver(self, selector:  #selector(UserSignInViewController.completedSignup), name: NSNotification.Name(rawValue: User.userInitCompleteNotification), object: nil)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func facebookLogin(_ sender: UIButton) {
        UserManager.loginWithFacebookSDK(viewController: self)
        
    }
    
    func cleanFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func completedSignup () {
        if let pwvc = self.parent as? ProfileWrapperViewController  {
            pwvc.showForUser()
            
        }
    }
    
    func failedSingup() {
        let alert = UIAlertController(title: "Failed", message: "Unable to log in.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func signUpLogIn(_ sender: AnyObject) {
        pause()
        view.endEditing(true)
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
//                User.singUpLogIn(email, password: password, restore: restore())
            } else {
                //reject
            }
        } else {
            //reject
        }
    }
    
    
    func pause(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func restore(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}

extension UserSignInViewController : UITextFieldDelegate {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UserSignInViewController : FacebookLoginController {
    func facebookLoginSucceed() {
        parentContainer.showForUser()
    }
    
    func facebookLoginFailed() {
        print("failed")
    }
    
}
