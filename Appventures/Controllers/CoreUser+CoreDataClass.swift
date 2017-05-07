//
//  CoreUser+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import FBSDKCoreKit


//@objc(CoreUser)
public class CoreUser: NSManagedObject {
    
    static var user: CoreUser?
    
    var userType: UserType {
        get { return UserType(rawValue: self.userTypeInt) ?? .noLogin }
        set {
            self.userTypeInt = newValue.rawValue
        }
    }
    
    var appventuresArray: [Appventure] {
        get {
            guard let appventures = ownedAppventures else { return [Appventure]() }
            return Array(appventures)
        }
    }
    var downloadedArray: [Appventure] {
        get {
            guard let appventures = downloaded else { return [Appventure]() }
            if appventures.count > 0 {
                return Array(appventures)
            } else {
                return [Appventure]()
            }
        }
    }
    
    var facebookFriends = [UserFriend]()
    
    /// Check if cached user object exists. Otherwise load from context or create in context.
    static func checkLogin(_ required: Bool = true, vc: UIViewController?) -> Bool {
        if CoreUser.user?.userType == .noLogin {
            return false
        } else {
            return true
        }
    }
    
    func loadFacebookPicture(completion: @escaping (UIImage) -> ()) {
        
        guard let url = pictureUrl else { return }
        print(url)
        DispatchQueue.global(qos: .userInitiated).async {
            if let getURL = URL(string: url) {
                if let data = try? Data(contentsOf: getURL){
                    guard let image = UIImage(data: data) else { return }
//                    self.facebookPicture = image
                    completion(image)
                }
            }
        }
    }
    
    func getFBImage() {
        if let url = self.pictureUrl as String! {
            if let getURL = URL(string: url) {
                if let data = try? Data(contentsOf: getURL){
                    let image = UIImage(data: data)
                    self.facebookPicture = image
                }
            }
        }
    }
    
    
}


// MARK: Facebook

extension CoreUser {
    
    func getFriends(completion: @escaping () -> ()) {
      facebookFriends.removeAll()
        let fbGraph = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: ["fields": "first_name, last_name, picture.type(small)"])
        _ = fbGraph?.start(completionHandler: { (connection, resultAny, error) -> Void in
            if error != nil {
                print("Error: \(error)")
            }
            else {
                let result = resultAny as AnyObject
                if let friendArray = result.object(forKey: "data") as? NSArray {
                    for friend in friendArray {
                        if let pictureURL = (friend as AnyObject).value(forKeyPath: "picture.data.url") as? String {
                            let friendFirstName = (friend as AnyObject).value(forKey: "first_name") as! String
                            let friendLastName = (friend as AnyObject).value(forKey: "last_name") as! String
                            let id = (friend as AnyObject).value(forKey: "id") as! String
                            let url = URL(string: pictureURL)
                            let userFriend = UserFriend(id: id, firstName: friendFirstName, lastName: friendLastName, url: url!)
                            self.facebookFriends.append(userFriend)
                        }
                    }
                    completion()
                }
                
            }
        })
    }

}

enum UserType: Int16 {
    case noUser = 0
    case noLogin
    case backendlessOnly
    case facebook
}
