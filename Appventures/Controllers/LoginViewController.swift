//
//  LoginViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4
import AVKit
import AVFoundation

var centralDispatchGroup = DispatchGroup()

protocol LoginViewControllerDelegate: class {
    func loginSucceed()
    func loginFailed()
}

class LoginViewController: UIViewController {
    
    var player: AVPlayer?
    
    weak var delegate: LoginViewControllerDelegate!
    let backendless = Backendless.sharedInstance()
    var user = BackendlessUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addVideoPlayer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
         NotificationCenter.default.post(name: Notification.Name(rawValue: skipLoginNotification), object: self)
    }


    @IBAction func facebookLogin(_ sender: UIButton) {
        centralDispatchGroup.enter()
        UserManager.loginWithFacebookSDK(viewController: self)
    }
    
    func addVideoPlayer() {
        
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "video", withExtension: "mov")!
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(LoginViewController.loopVideo),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}

extension LoginViewController : FacebookLoginController {
    func facebookLoginSucceed() {
        delegate.loginSucceed()
    }
    
    func facebookLoginFailed() {
        delegate.loginFailed()
    }
}
