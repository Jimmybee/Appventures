//
//  EmailLoginViewController.swift
//  Appventures
//
//  Created by James Birtwell on 17/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class CreateAccountViewController: BaseViewController {
    
    weak var delegate: PresentingViewController!

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    var responders: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        responders = [firstName, lastName, email, password]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fadeIn()
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 1
        }) { (complete) in
            self.firstName.becomeFirstResponder()
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.resignResponders()
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.alpha = 0
        }) { (complete) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        password.isSecureTextEntry = !password.isSecureTextEntry
    }
    
    @IBAction func submit(_ sender: UIButton?) {
        self.resignResponders()
        let account = CreateAccount(firstName: firstName.text ?? "", lastName: lastName.text ?? "", email: email.text!, password: password.text!)

        showProgressView()
        UserManager.createAccount(account: account) { (complete) in
            self.hideProgressView()
            if complete {
                self.dismiss(animated: true, completion: {
                    self.delegate.dismissSelf()
                })
            } else {
                print("handle error")
            }
        }
        
    }
    
    func resignResponders() {
        responders.forEach({ $0.resignFirstResponder()})
    }
}


extension CreateAccountViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstName:
            lastName.becomeFirstResponder()
            return true
        case lastName:
            email.becomeFirstResponder()
            return true
        case email:
            password.becomeFirstResponder()
            return true
        default:
            password.resignFirstResponder()
            submit(nil)
            return true
        }
    }
}
