//
//  FriendsAdventures.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

class SharedAdventure: NSObject {
    
    var creatorFbId: String?
    var shareeFbId: String?
    var appventureId: String?
    var fullAccessLevel: Bool = true
    
    
    override init() {
        super.init()
    }
    
    init(shareeFbId: String, appventureId: String) {
        self.creatorFbId = CoreUser.user!.facebookId!
        self.shareeFbId = shareeFbId
        self.appventureId = appventureId
    }
    
    
    init(backendlessDictionary: Dictionary<String,  Any>) {
        self.creatorFbId = backendlessDictionary["creatorFbId"] as? String
        self.shareeFbId = backendlessDictionary["shareeFbId"] as? String
        self.appventureId = backendlessDictionary["appventureId"] as? String
    }
    
    func save(completion: @escaping () -> ()) {
        BackendlessAppventure.dataStore?.save(self, response: { (returnObject) in
            guard let dict = returnObject as? Dictionary<String, Any> else { return }
            completion()
            print(dict)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    class func getGrantedSharedAppventures(shareeFbId: String, completion: @escaping ([Appventure]?) -> ()) {
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "shareeFbId = \(shareeFbId)"
        
        let dataStore = Backendless.sharedInstance().data.of(SharedAdventure.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            guard let page1 = collection!.getCurrentPage() else { return completion(nil) }
            let sharedAppventures = page1.map(self.convertToSharedAppventure).flatMap( { $0 })
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = "objectId in (\(sharedAppventures.joined(separator: " OR ")))"
            BackendlessAppventure.loadBackendlessAppventures(persistent: true, dataQuery: dataQuery, completion: { (appventures, fault) in
                if fault != nil {
                    completion(nil)
                } else {
                    completion(appventures as! [Appventure]?)
                }
            })
        }, error: { (fault) in
            print("Server reported an error: \(String(describing: fault))")
            completion(nil)
        })
        
    }
    
    private class func convertToSharedAppventure(obj: Any?) -> String? {
        guard let dict = obj as? Dictionary<String, Any> else { return nil }
        guard let sharedName = SharedAdventure(backendlessDictionary: dict).appventureId else { return nil }
        return ("'\(sharedName)'")
    }
    
    

}
