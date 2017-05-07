//
//  ImageFullscreenViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 12/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ImageFullscreenViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()

    }}
    
    var imageView = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        scrollView?.contentSize = imageView.frame.size

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
