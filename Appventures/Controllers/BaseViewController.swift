//
//  ViewControllerExtension.swift
//  Appventures
//
//  Created by James Birtwell on 20/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var activityView = UIActivityIndicatorView()
    
    private(set) lazy var progressView: UIView = {
        let size = CGSize(width: 60, height: 60)
        let center = CGPoint(x: UIScreen.main.bounds.size.width / 2 - 30, y: UIScreen.main.bounds.size.height / 2 - 30)
        let progressView = UIView(frame: CGRect(origin: center, size: size))
        progressView.accessibilityIdentifier = "progressView"
        progressView.backgroundColor = UIColor.black
        progressView.layer.opacity = 0.8
        progressView.layer.cornerRadius = 8
        
        self.activityView.center = CGPoint(x: progressView.bounds.size.width/2, y: progressView.bounds.size.height/2)
        progressView.addSubview(self.activityView)
        return progressView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension BaseViewController {
    
    func showProgressView() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(progressView)
        activityView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideProgressView() {
        activityView.stopAnimating()
        progressView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
