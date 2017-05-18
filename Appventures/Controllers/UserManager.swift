//
//  UserManager.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UserManager {
    
    static var backendless = Backendless.sharedInstance()
    
    struct backendlessFields {
        static let facebookId = "facebookId"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    static let fieldsMapping = [
        "id" : backendlessFields.facebookId,
        "birthday": "birthday",
        "first_name": "firstName",
        "last_name" : "lastName",
        "gender": "gender",
        "email": "email",
    ]
    
    /// check if logged in to backendless.
    /// then attempt to load coreData.
    /// Load latest coredata user. Check if core
    static func setupUser(completion: @escaping () -> ()) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext

        let backendless = Backendless.sharedInstance()
        if backendless?.userService.currentUser == nil {
            CoreUser.user = CoreUser(context: context)
            CoreUser.user?.userType = .noLogin
            AppDelegate.coreDataStack.saveContext(completion: nil)
            completion()
            return
        }
        
        do {
            let fetchRequest: NSFetchRequest<CoreUser> = CoreUser.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if users.count == 0 {
                CoreUser.user = CoreUser(context: context)
                AppDelegate.coreDataStack.saveContext(completion: nil)
            } else {
                let backendlessId =  Backendless.sharedInstance().userService.currentUser.objectId as String
                let user = users.filter({ $0.backendlessId == backendlessId}).first ?? users[0]
                print(user)
                CoreUser.user = user
                AppDelegate.coreDataStack.saveContext(completion: nil)
            }
        } catch {
            CoreUser.user = CoreUser(context: context)
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
        
        
        backendless?.userService.isValidUserToken({ (valid) in
            if FBSDKAccessToken.current() == nil {
//                CoreUser.user?.userType = .backendlessOnly
            } else {
                
//                CoreUser.user?.userType = .facebook
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
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let user = backendless!.userService.currentUser
        let userId = user?.objectId as String?
        if CoreUser.user?.backendlessId != userId { CoreUser.user = CoreUser(context: context) }
        CoreUser.user?.backendlessId = user?.objectId as String?
        CoreUser.user?.name = user?.getProperty(backendlessFields.firstName) as? String
        if let facebookId = user?.getProperty(backendlessFields.facebookId) as? String {
            CoreUser.user?.facebookId = facebookId
            CoreUser.user?.pictureUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
            CoreUser.user?.userType = .facebook
        } else {
            CoreUser.user?.userType = .backendlessOnly
        }
        DispatchQueue.main.async {
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
    }
    
    static func loginWithFacebookSDK(viewController: UIViewController) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: viewController) { (result, error) in
            let token = FBSDKAccessToken.current()
            if token == nil {
                print(error ?? "Facebook token error")
                return
            }
            backendless?.userService.login(withFacebookSDK: token, fieldsMapping: fieldsMapping, response: { (user) in
                mapBackendlessToCoreUser()
                viewController.dismiss(animated: false, completion: nil)
            }, error: { (fault) in
                guard let fault = fault else { return }
                print("Server reported an error: \(fault)")
            })
        }
    }
    
    static func createAccount(account: CreateAccount,  completion: @escaping (Bool) -> ()) {
        let user = BackendlessUser()
        user.setProperty("firstName", object: account.firstName)
        user.setProperty("lastName", object: account.lastName)
        user.email = account.email as NSString
        user.password = account.password as NSString

        backendless?.userService.registering(user, response: { (user) in
            loginWith(email: account.email, password: account.password, completion: { (complete) in
                completion(true)
            })
        }, error: { (fault) in
            completion(false)
            print("Server reported an error: \(fault!)")
        })
    }
    
    static func loginWith(email: String, password: String, completion: @escaping (Bool) -> ()) {

        backendless?.userService.login(email, password: password, response: { (user) in
            mapBackendlessToCoreUser()
            completion(true)
        }, error: { (fault) in
            guard let fault = fault else { return }
            print("Server reported an error: \(fault)")
            completion(false)
        })
    }
    
    static func logout() {
        backendless!.userService.logout()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
}

struct CreateAccount {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

