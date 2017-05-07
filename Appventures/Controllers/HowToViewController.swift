//
//  HowToViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var scrollPageDots: UIPageControl!
    
   
    @IBOutlet weak var imageThree: UIImageView!
    struct Constants {
        static let sbName = "HowToVC"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        HelperFunctions.circle(imageOne)
        HelperFunctions.circle(imageTwo)
        HelperFunctions.circle(imageThree)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension HowToViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollPageDots.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}
