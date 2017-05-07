//
//  Review.swift
//  EpicAppventures
//
//  Created by James Birtwell on 27/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
//import Parse

class AppventureReviews: NSObject {
    
    static let appventureReviewsHC = "reviewsHC"

    
    struct parseCol {
        static let pfClass = "RatingReview"
        static let userFKID = "userID"
        static let date = "date"
        static let appventureFKID = "appventureFKID"
        static let review = "review"
    }
    
    
    var pfObjectID = ""
    var userFKID = ""
    var appventureFKID = ""
    var date = Date()
    var review = ""
    
    init(userFKID: String, review: String, appventureFKID: String, date: Date) {
        self.userFKID = userFKID
        self.review = review
        self.appventureFKID = appventureFKID
        self.date = date
    }
    
    init(object: AnyObject) {
//        self.pfObjectID = object.objectId!
//        self.userFKID = object.objectForKey(parseCol.userFKID) as! String
//        self.appventureFKID = object.objectForKey(parseCol.appventureFKID) as! String
//        self.review = object.objectForKey(parseCol.review) as! String
//        self.date = object.objectForKey(parseCol.date) as! NSDate
    }
    
    func save(){
//        if self.pfObjectID == "" {
//            let saveObj = PFObject(className: parseCol.pfClass)
//            saveObject(saveObj)
//        } else {
//            ParseFunc.getParseObject(self.pfObjectID, pfClass:  parseCol.pfClass, objFunc: saveObject)
//        }
    }
    
//    private func saveObject(save: PFObject) {
//        save[parseCol.userFKID] = self.userFKID
//        save[parseCol.appventureFKID] = self.appventureFKID
//        save[parseCol.review] = self.review
//        save[parseCol.date] = self.date
//        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                print(errorString)
//            } else {
//                self.pfObjectID = save.objectId!
//                print("savedRR")
//            }
//        }
//    }
    
//    class func loadAppventuresReviews(_ appventureID: String, handler: ParseQueryHandler) {
//        ParseFunc.parseQuery(parseCol.pfClass, location2D: nil, whereClause: appventureID, WhereKey: parseCol.appventureFKID, vcHandler: handler, handlerCase: appventureReviewsHC)
//    }
    
    
}

