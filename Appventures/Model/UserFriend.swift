//
//  UserFriendList.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
import Kingfisher

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
        let processor = RoundCornerImageProcessor(cornerRadius: 30)
        let resource = ImageResource(downloadURL: pictureURL)
        cell.profilePictureView.kf.setImage(with: resource, placeholder: nil, options: [.processor(processor), .transition(.fade(0.2))], progressBlock: nil) { (image, error, type, url) in
            self.profilePicture = image
        }
    }
    
}
