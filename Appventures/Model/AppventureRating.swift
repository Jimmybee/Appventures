//
//  AppventureRating.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

protocol AppventureRatingDelegate : NSObjectProtocol {
    func ratingLoaded()
}

class AppventureRating: NSObject {
    
    static let appventureRatingHC = "ratingsHC"
    

    var pfObjectID = ""
    var appventureFKID = ""
    var rating = 0
    
    init(appventureFKID: String, rating: Int) {
        self.appventureFKID = appventureFKID
        self.rating = rating
    }
    
    init(object: AnyObject) {

    }
    
    func save(){

    }
    

    class func loadRating(_ appventure: Appventure, handler: AppventureRatingDelegate?) {

    }
    
    
    
}
