//
//  FlaggedContent.swift
//  EA - Clues
//
//  Created by James Birtwell on 08/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//


import Foundation

class FlaggedContent: NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(Rating.ofClass())
    
    enum Status: Int {
        case New = 0, Review, Resolved
    }
    
    var appventureFKID:String? = ""
    var stepFKID:String? = ""
    var feedback:String? = ""
    private var status:Int? = 0
    
    var statusEnum: Status {
        get {
            guard let status = status else {return Status.New}
            return Status(rawValue: status) ?? Status.New
        }
        set {
            status = newValue.rawValue
        }
    }
    
    func save(){
        FlaggedContent.dataStore?.save(self, response: { (response) in
            print("success")
        }, error: { (error) in
            print("error")
        })
    }
}


