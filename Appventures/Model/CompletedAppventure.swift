//
//  Review.swift
//  EpicAppventures
//
//  Created by James Birtwell on 27/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation

class CompletedAppventure: NSObject {
    
    var teamName: String?
    var appventureId: String?
    var time: Double = 0.0
    
    init(teamName: String?, appventureId: String?, time: Double) {
        self.teamName = teamName
        self.appventureId = appventureId
        self.time = time
    }
    
    init(backendlessDictionary: Dictionary<String,  Any>) {
        teamName = backendlessDictionary["teamName"] as? String
        appventureId = backendlessDictionary["appventureId"] as? String
        time = backendlessDictionary["time"] as? Double ?? 0.0
    }
    
    func save(completion: @escaping () -> ()){
        BackendlessAppventure.dataStore?.save(self, response: { (returnObject) in
            guard let dict = returnObject as? Dictionary<String, Any> else { return }
            completion()
            print(dict)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    class func loadLeaderboardFor(appventureId: String, completion: @escaping ([CompletedAppventure]?) -> ()) {
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "appventureId = '\(appventureId)'"
        
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["time"])
        dataQuery.queryOptions = queryOptions
        
        let dataStore = Backendless.sharedInstance().data.of(self.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            guard let page1 = collection!.getCurrentPage() else { return completion(nil) }
            let completedAppventures = page1.map(convertToCompletedAppventure).flatMap({$0})
            completion(completedAppventures)
        }, error: { (fault) in
            print("Server reported an error: \(fault)")
            completion(nil)
        })
        
    }
    
    private class func convertToCompletedAppventure(obj: Any) -> CompletedAppventure? {
        guard let dict = obj as? Dictionary<String, Any> else { return nil }
        return CompletedAppventure(backendlessDictionary: dict)
    }
    
    class func countCompleted(completion: @escaping ([CompletedAppventure]?) -> ()) {
        let dataQuery = BackendlessDataQuery()

        guard let userId = Backendless.sharedInstance().userService.currentUser.objectId else { return }
        dataQuery.whereClause = "ownerId = \(userId)"
        
        let dataStore = Backendless.sharedInstance().data.of(self.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            guard let page1 = collection!.getCurrentPage() else { return }
            let completedAppventures = page1.map(convertToCompletedAppventure).flatMap({$0})
            completion(completedAppventures)
        }, error: { (fault) in
            print("Server reported an error: \(fault)")
            completion(nil)
        })
    }


}
