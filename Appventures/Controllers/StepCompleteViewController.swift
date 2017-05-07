//
//  StepCompleteViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 27/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit

protocol StepCompleteViewControllerDelegate : NSObjectProtocol {
    
    func setTime(_ currentTime : Double )
    
}
class StepCompleteViewController: UIViewController {
    
    var step: AppventureStep!
    lazy var currentTimeD = 0.0
    weak var delegate : StepCompleteViewControllerDelegate!

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var completionText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completionText.text = step.completionText
        self.currentTime.text = HelperFunctions.formatTime(currentTimeD, nano: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextStep(_ sender: UIButton) {
        delegate.setTime(currentTimeD)
        dismiss(animated: true,completion: nil)
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
