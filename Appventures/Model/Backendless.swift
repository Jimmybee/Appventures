//
//  Backendless.swift
//  EA - Clues
//
//  Created by James Birtwell on 08/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessDataStack {
    
    class func loadBackendless(type: NSObject, persistent: Bool, dataQuery: BackendlessDataQuery?, completion: @escaping ServiceNewResponse) {
        let dataStore = Backendless.sharedInstance().data.of(type.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            completion(collection as AnyObject?, nil)
        }, error: { (fault) in
            print("Server reported an error: \(fault)")
            completion(nil, fault)
        })
    }
    
}
