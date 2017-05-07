//
//  SettingsViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 28/07/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation


import UIKit
//import Parse
import FBSDKShareKit
import FBSDKCoreKit

class SettingsTableViewController: UITableViewController {
    
    let rtfDisplay = "rtfDisplay"
    let UserAppventuresHC = "UserAppventuresHC"
    
    var myTable = UITableView()
    
    @IBOutlet weak var howToPlayCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    @IBOutlet weak var choosingAdventureCell: UITableViewCell!
    @IBOutlet weak var makingAdventureCell: UITableViewCell!
    @IBOutlet weak var licencesCell: UITableViewCell!
    @IBOutlet weak var privacyCell: UITableViewCell!
    @IBOutlet weak var restoreDataCell: UITableViewCell!

    
    @IBOutlet weak var createdAdventuresCount: UILabel!
    @IBOutlet weak var completedAdventuresCount: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileHeaderContainer: UIView!
    @IBOutlet weak var nonFacebookHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: Get container view controllers & Navigation
    var embeddedProfileHeader: ProfileHeaderViewController!
    var embeddedNonFacebookHeader: NonFacebookHeaderViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileHeaderViewController {
            self.embeddedProfileHeader = vc
        }
        if let vc = segue.destination as? NonFacebookHeaderViewController {
            self.embeddedNonFacebookHeader = vc
        }
        
        if segue.identifier == rtfDisplay {
            if let rdvc = segue.destination as? RTFDisplayViewController {
                if let rtfName = sender as? String  {
                    rdvc.rtfName = rtfName
                }
            }
        }
    }
    
    func updateUI() {
        if let user = CoreUser.user {
//            self.completedAdventuresCount.text = String(User.user!.completedAdventures)
//            CompletedAppventure.countCompleted(self)
//            Appventure.loadUserAppventure(User.user!.pfObject, handler: self, handlerCase: "")
            user.userType == .facebook ? (self.setupHeaderView()) : self.parseUserHeader()
        }
    }
    
    //MARK: HeaderView
    
    func setupHeaderView () {
        
        profileHeaderContainer.alpha = 1
        nonFacebookHeader.alpha = 0
        if let picture = CoreUser.user?.facebookPicture {
            embeddedProfileHeader.circledImageView.image = picture
            embeddedProfileHeader.updateCircleImage()
        } else {
            // start spinner
            CoreUser.user?.loadFacebookPicture(completion: { (image) in
                //if success
                DispatchQueue.main.async {
                    print(Thread.isMainThread)
                    self.embeddedProfileHeader.circledImageView.image = image
                    CoreUser.user?.facebookPicture = image
                    AppDelegate.coreDataStack.saveContext(completion: nil)
                    self.embeddedProfileHeader.updateCircleImage()
                }
//                stop spinner
//                if fail display ?
            })
        }
    
        embeddedProfileHeader.nameLabel.text = CoreUser.user?.name
        
        if CoreUser.user!.facebookPicture != nil {
//            if let blur = User.user!.blurPicture {
//                embeddedProfileHeader.blurredImageView.image = blur
//            } else {
//                let frame = embeddedProfileHeader.blurredImageView.frame
//                let blurImageSized = HelperFunctions.resizeImage(User.user!.profilePicture!, newWidth: 600)
//                if let blurImage = HelperFunctions.blurImage(blurImageSized, radius: 8, forRect: frame) {
//                    embeddedProfileHeader.blurredImageView.image = blurImage
//                    User.user?.blurPicture = blurImage
//                    User.user?.saveLocalData()
//                }
//            }
        } else {
//            User.user?.getFBImage()
        }
    }

    func parseUserHeader() {
        profileHeaderContainer.alpha = 0
        nonFacebookHeader.alpha = 1
        embeddedNonFacebookHeader.headerLabel.text = "User1"
    }

}

// MARK: - Table functions

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            switch cell {
            case logOutCell:
                logoutPopup()
            case restoreDataCell:
                restoreLocalData()
            case howToPlayCell:
                self.performSegue(withIdentifier: rtfDisplay, sender: RTFs.howToPlay)
            case choosingAdventureCell:
                self.performSegue(withIdentifier: rtfDisplay, sender: RTFs.choosingAdventure)
            case makingAdventureCell:
                self.performSegue(withIdentifier: rtfDisplay, sender: RTFs.makingAnAdventure)
            case privacyCell:
                self.performSegue(withIdentifier: rtfDisplay, sender: RTFs.privacyPolicy)
            case licencesCell:
                self.performSegue(withIdentifier: rtfDisplay, sender: nil)
            default:
                break
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    private func logoutPopup() {
        let alert = UIAlertController(title: "Log out user", message: "Log out user", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.destructive, handler: { action in
            UserManager.logout()
            if let pwvc = self.parent as? ProfileWrapperViewController  {
                pwvc.showForSignIn()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func restoreLocalData() {
        // TODO: Call context reset and load all backendless appventures owned by user.
    }
}




extension SettingsTableViewController : UserDataHandler {
    func userFuncComplete(_ funcKey: String) {
//        switch funcKey{
//        case User.funcKeys.fbGraphLoaded:
//            print("fbGraphloaded")
////            profileHeaderView.nameLabel.text = "\(User.user!.firstName) \(User.user!.lastName)"
//        case User.funcKeys.fbImageLoaded:
//            print("fbGraphloaded")
//
////            self.setupHeaderView()
////            self.saveLocalData()
//        case User.funcKeys.localDataLoaded:
//            print("fbGraphloaded")
//
////            self.setupHeaderView()
//        default: break
//        }
    }
}

