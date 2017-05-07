//
//  FlaggedContent.swift
//  EA - Clues
//
//  Created by James Birtwell on 08/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//


import Foundation
//import Parse

class FlaggedContent: NSObject {
    
    static let appventureReviewsHC = "reviewsHC"
    
    struct parseCol {
        static let pfClass = "FlaggedContent"
        static let userFKID = "userID"
        static let date = "date"
        static let appventureFKID = "appventureFKID"
        static let stepFKID = "stepFKID"
        static let status = "status"
    }
    
    enum Status: Int {
        case new = 1
        case inDispute = 2
        case resolved = 3
    }
    
    var pfObjectID = ""
    var appventureFKID = ""
    var date = Date()
    var stepFKID = ""
    var status:Status = Status.new
    
    init(appventureFKID: String, stepFKID: String) {
        self.appventureFKID = appventureFKID
        self.stepFKID = stepFKID    
    }
    
    init(object: AnyObject) {
//        self.pfObjectID = object.objectId!
//        self.appventureFKID = object.objectForKey(parseCol.appventureFKID) as! String
//        self.stepFKID = object.objectForKey(parseCol.stepFKID) as! String
//        self.date = object.objectForKey(parseCol.date) as! NSDate
//        if let statusIs = object.objectForKey(parseCol.date) as? Int {
//            self.status = Status(rawValue: statusIs)!
//        }
    }
    
    func save(){
//        if self.pfObjectID == "" {
//            let saveObj = PFObject(className: parseCol.pfClass)
//            saveObject(saveObj)
//        } else {
//            ParseFunc.getParseObject(self.pfObjectID, pfClass:  parseCol.pfClass, objFunc: saveObject)
//        }
    }
    
    fileprivate func saveObject(_ save: AnyObject) {
//        save[parseCol.appventureFKID] = self.appventureFKID
//        save[parseCol.stepFKID] = self.stepFKID
//        save[parseCol.date] = self.date
//        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                print(errorString)
//            } else {
//                self.pfObjectID = save.objectId!
//                print("contentFlagged")
//            }
//        }
    }
    
//    class func loadFlaggedContent(_ appventureID: String, handler: ParseQueryHandler) {
//        ParseFunc.parseQuery(parseCol.pfClass, location2D: nil, whereClause: appventureID, WhereKey: parseCol.appventureFKID, vcHandler: handler, handlerCase: appventureReviewsHC)
//    }
    
    
}


