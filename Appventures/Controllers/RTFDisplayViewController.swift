//
//  RTFDisplayViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 17/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class RTFDisplayViewController: UIViewController {

    @IBOutlet weak var rtfTextView: UITextView!
    var rtfName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if rtfName == "" {
            getLicences()
        } else  {
            rtfAsset()
        }
        
    }
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLicences() {
        rtfTextView.text = Licensing.placesLicense + Licensing.serviceLicense
    }
    
    func rtfAsset () {
        if let asset = NSDataAsset(name: rtfName) {
            let options =  [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType]
            
            do {
                let attributedString = try  NSAttributedString(data: asset.data, options: options, documentAttributes: nil)
                
                rtfTextView.attributedText = attributedString
                rtfTextView.isEditable = false
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
