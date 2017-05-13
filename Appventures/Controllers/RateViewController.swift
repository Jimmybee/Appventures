//
//  RateViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class RateViewController: UIViewController, UITextViewDelegate {
    
    //Model
    var ratingReview: Rating!
    var keyboardShowing = false

    
    //Views
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var ratingControlContainer: UIView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var leaveFeedback: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        ratingControl.callback = updatedRating
        
        leaveFeedback.alpha = 0
        reviewTextView.alpha = 0
        reviewTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)


    }
    
    func setupTextView() {
        reviewTextView.layer.borderWidth = 1.5
        reviewTextView.layer.cornerRadius = 12
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.black.cgColor
    }
    

    func saveRating () {
        if ratingControl.rating != 0 {

        }
    }

    @IBAction func submitRating(_ sender: AnyObject) {
        ratingReview.review = reviewTextView.text
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatedRating(rating: Int) {
        ratingReview.rating = rating
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveLinear, animations: {
            self.ratingControlContainer.alpha = 0
        }) { (complete) in
            UIView.animate(withDuration: 0.1, animations: {
                self.reviewTextView.alpha = 1
                self.leaveFeedback.alpha = 1
            })
        }

    }
    
    func keyboardShow(_ n:Notification) {
        if self.keyboardShowing {
            return
        }
        self.keyboardShowing = true
        
        
        print("show")
        
        let d = n.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        r = self.reviewTextView.convert(r, from:nil)
        self.reviewTextView.contentInset.bottom = r.size.height
        self.reviewTextView.scrollIndicatorInsets.bottom = r.size.height
        
        
        
    }
    
    func keyboardHide(_ n:Notification) {
        if !self.keyboardShowing {
            return
        }
        self.keyboardShowing = false
        
        print("hide")
        
        self.reviewTextView.contentInset = .zero
        self.reviewTextView.scrollIndicatorInsets = .zero
        
        
    }

}
