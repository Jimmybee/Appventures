//
//  WriteReviewViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class EditTextClueViewController: UIViewController {
    
    var step: AppventureStep!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reviewTextView.delegate = self
        reviewTextView.text = step.initialText
        reviewTextView.layer.borderWidth = 1.5
        reviewTextView.layer.cornerRadius = 12
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.black.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditTextClueViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(EditTextClueViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(_ sender: UIBarButtonItem) {
        step.initialText = reviewTextView.text
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 20

        })
    }
    
  
}


extension EditTextClueViewController : UITextViewDelegate {
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        if textView.text == Constants.reviewTextViewDefaults {
//            textView.textColor = UIColor.blackColor()
//            textView.text = ""
//        }
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
