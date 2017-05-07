//
//  UserManager.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import FBSDKLoginKit

protocol FacebookLoginController {
    func facebookLoginSucceed()
    func facebookLoginFailed()
}

protocol UserDataHandler : NSObjectProtocol {
    func userFuncComplete(_ funcKey: String)
}

class UserManager {
    
    static var backendless = Backendless.sharedInstance()
    
    struct backendlessFields {
        static let facebookId = "facebookId"
        static let name = "name"
        static let pictureUrl = "pictureURL"
    }
    
    static let fieldsMapping = [
        "id" : backendlessFields.facebookId,
        "name" : backendlessFields.name,
        "birthday": "birthday",
        "first_name": "fb_first_name",
        "last_name" : "fb_last_name",
        "gender": "gender",
        "email": "email",
//        "pictureURL": backendlessFields.pictureUrl
        
    ]
    
    
    /// Load latest coredata user. Check if core
    static func setupUser(completion: @escaping () -> ()) {

        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<CoreUser> = CoreUser.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if users.count == 0 {
                CoreUser.user = CoreUser(context: context)
                AppDelegate.coreDataStack.saveContext(completion: nil)
            } else {
                CoreUser.user = users[0]
            }
        } catch {
            CoreUser.user = CoreUser(context: context)
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
        
        
        let backendless = Backendless.sharedInstance()
        if backendless?.userService.currentUser == nil {
            CoreUser.user?.userType = .noLogin
            completion()
            return
        }
        
        
        backendless?.userService.isValidUserToken({ (valid) in
            if FBSDKAccessToken.current() == nil {
                CoreUser.user?.userType = .backendlessOnly
            } else {
                
                CoreUser.user?.userType = .facebook
            }
            completion()
            return
        }, error: { (fault) in
            print(fault!)
            _ =  backendless?.userService.logout()
            CoreUser.user?.userType = .noLogin
            completion()
            return
        })
        
    }
    
    static func mapBackendlessToCoreUser() {
        let user = backendless!.userService.currentUser
        CoreUser.user?.name = user?.getProperty(backendlessFields.name) as? String
        CoreUser.user?.facebookId = user?.getProperty(backendlessFields.facebookId) as? String
        CoreUser.user?.pictureUrl = "https://graph.facebook.com/\(CoreUser.user!.facebookId!)/picture?type=large"
        CoreUser.user?.userType = .facebook
        DispatchQueue.main.async {
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
    }
    
    static func loginWithFacebookSDK(viewController: UIViewController) {
        guard let facebookLoginController = viewController as? FacebookLoginController else { return }
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: viewController) { (result, error) in
            let token = FBSDKAccessToken.current()
            backendless?.userService.login(withFacebookSDK: token, fieldsMapping: fieldsMapping, response: { (user) in
                mapBackendlessToCoreUser()
                viewController.dismiss(animated: true, completion: nil)
                facebookLoginController.facebookLoginSucceed()
            }, error: { (fault) in
                print("Server reported an error: \(fault)")
                facebookLoginController.facebookLoginFailed()
            })
        }
    }
    
    static func logout() {
        backendless!.userService.logout()
    }
    
}


