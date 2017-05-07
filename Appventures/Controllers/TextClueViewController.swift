//
//  ImageClueViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class TextClueViewController: UIViewController {

    
    lazy var clueText : String? = ""
    @IBOutlet weak var clueTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        clueTextView.text = clueText    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
