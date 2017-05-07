//
//  WriteReviewViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {
    
    var appventure: Appventure!
    
    struct Constants {
        static let reviewTextViewDefaults = "write a review..."
    }
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.textColor = UIColor.gray
        reviewTextView.text = Constants.reviewTextViewDefaults
        
        reviewTextView.layer.borderWidth = 1.5
        reviewTextView.layer.cornerRadius = 12
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
//        if let currentUser = CoreUser.user {
//            let reviewObject = AppventureReviews(userFKID: currentUser.pfObject, review: reviewTextView.text, appventureFKID: appventure.backendlessId!, date: Date())
//            reviewObject.save()
//        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension WriteReviewViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constants.reviewTextViewDefaults {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        return true
    }
    
    //    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //        if(text == "\n") {
    //            textView.resignFirstResponder()
    //            return false
    //        }
    //        return true
    //    }
    
}
