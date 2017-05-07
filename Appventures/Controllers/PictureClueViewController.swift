//
//  PictureClueViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class PictureClueViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    lazy var clueImage =  UIImage()
    @IBOutlet var imageView: UIImageView!
    
    weak var delegate: PictureClueViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = self.view.bounds.size
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    }
    
    func setup () {
        imageView.image = clueImage
    }
    
    func zoomOut() {
        scrollView.isScrollEnabled = false
        scrollView.zoomScale = 1
    }
    
    @IBAction func zoomTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.isScrollEnabled = true
            scrollView.zoomScale = 2
        } else {
             zoomOut()
        }
    }


}

extension PictureClueViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

protocol PictureClueViewControllerDelegate : NSObjectProtocol {
    func closePan ()
}
