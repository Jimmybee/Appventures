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
    
    private(set) lazy var reachability: Reachability = {
        var new: Reachability!
        do {
            new = try Reachability()
        } catch {
            
        }
        return new!
    }()

    var activityView = UIActivityIndicatorView()
    
    var overlayView: UIView!
    
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
    
    func dismissSender(sender: UIView) {
        overlayView.removeFromSuperview()
        overlayView = nil
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

protocol ViewControllerHelpers {
    
}

extension ViewControllerHelpers where Self: BaseViewController {
    
    func fullScreenTooltip() -> UIView  {
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 30)
        let origin = CGPoint(x:0, y: 0)
        let progressView = UIView(frame: CGRect(origin: origin, size: size))
        progressView.backgroundColor = UIColor.black
        progressView.layer.opacity = 0.7
        return progressView
    }
    
    private func dismissGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action:  #selector(dismissSender))
        return gesture
    }
    
    private func toolTipLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func displayToolTip(message: String) {
        overlayView = fullScreenTooltip()
        UIApplication.shared.keyWindow?.addSubview(overlayView)
        
        let gesture = dismissGesture()
        overlayView.addGestureRecognizer(gesture)
        
        let tooltip = toolTipLabel()
        overlayView.addSubview(tooltip)
        tooltip.text = message
        tooltip.autoCenterInSuperview()
    }
    

}
