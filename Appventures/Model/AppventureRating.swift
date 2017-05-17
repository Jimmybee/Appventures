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

class Rating: NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(Rating.ofClass())
    
    var appventureId = ""
    var rating = 0
    var review = ""
    
    override init() {
        super.init()
    }
    
    init(appventureId: String) {
        self.appventureId = appventureId
    }
    
    
    func save(){
        guard rating != 0 else { return }
        Rating.dataStore?.save(self, response: { (response) in
            print("success")
        }, error: { (error) in
            print("error")
        })
    }
    

    class func loadReviews(_ appventureId: String, completion: @escaping ([Rating]?) -> ()) {
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "appventureId = '\(appventureId)' AND review != ''"
        
        let dataStore = Backendless.sharedInstance().data.of(self.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            
            if let page1 = collection!.getCurrentPage() {
                let ratings = page1.map({return $0 as? Rating}).flatMap({ $0})
                completion(ratings)
            }
        }, error: { (fault) in
            print("Server reported an error: \(String(describing: fault))")
            completion(nil)
        })
    }
    
    
    
}
