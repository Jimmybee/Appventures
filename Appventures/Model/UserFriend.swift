//
//  UserFriendList.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

class UserFriend: NSObject {
    
    let firstName: String
    let lastName: String
    let pictureURL: URL
    let id: String
    var profilePicture: UIImage? = nil
    
    
    init(id: String, firstName: String, lastName: String,  url: URL) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.pictureURL = url
        
    }
    
    func loadImageFor(cell: FacebookFriendTableCell) {
//            if let getURL = URL(string: pictureURL) {
                if let data = try? Data(contentsOf: pictureURL){
                    self.profilePicture = UIImage(data: data)
                    cell.profilePictureView.image = self.profilePicture
                    HelperFunctions.circle(cell.profilePictureView)
                }
//        }
    }
    
}
