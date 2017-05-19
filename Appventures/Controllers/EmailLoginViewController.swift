//
//  EmailLoginViewController.swift
//  Appventures
//
//  Created by James Birtwell on 17/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

protocol PresentingViewController: class {
    func dismissSelf()
}

extension PresentingViewController where Self: UIViewController {
    func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}


class EmailLoginViewController: BaseViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    weak var delegate: PresentingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fadeIn()
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 1
        }) { (complete) in
            self.emailTextField.becomeFirstResponder()
        }
    }

    @IBAction func backTapped(_ sender: UIButton) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()

        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 0
        }) { (complete) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var showPassword: UIButton!
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func submit(_ sender: UIButton?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
         let email =  "email@email.com"
         let password = "password"
//        let email = emailTextField.text  ??  "email@email.com"
//        let password = emailTextField.text ?? "password"
        showProgressView()
        UserManager.loginWith(email: email, password: password) { (complete) in
            self.hideProgressView()
            self.dismiss(animated: true, completion: {
                self.delegate.dismissSelf()
            })
        }
    }
}

extension EmailLoginViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            return true
        default:
            passwordTextField.resignFirstResponder()
            submit(nil)
            return true
        }
    }
}
