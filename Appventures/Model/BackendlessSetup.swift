//
//  BackendlessSetup.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessSetup: NSObject {
 
     public var textClue: Bool = false
     public var soundClue: Bool = false
     public var pictureClue: Bool = false
     public var checkIn: Bool = false
     public var isLocation: Bool = false
     public var locationShown: Bool = false
     public var compassShown: Bool = false
     public var distanceShown: Bool = false
     public var objectId: String!
    
    
    override init() {
        super.init()
    }
    
    init(setup: StepSetup) {
        self.objectId = setup.backendlessId
        self.textClue = setup.textClue
        self.soundClue = setup.soundClue
        self.pictureClue = setup.pictureClue
        self.checkIn = setup.checkIn
        self.isLocation  = setup.isLocation
        self.locationShown = setup.locationShown
        self.compassShown = setup.compassShown
        self.distanceShown = setup.distanceShown
    }
    
    init(dict: Dictionary<String, Any>) {
        self.objectId = dict["objectId"] as? String
        self.textClue = dict["textClue"] as! Bool
        self.soundClue = dict["soundClue"] as! Bool
        self.pictureClue = dict["pictureClue"] as! Bool
        self.checkIn = dict["checkIn"] as! Bool
        self.isLocation  = dict["isLocation"] as! Bool
        self.locationShown = dict["locationShown"] as! Bool
        self.compassShown = dict["compassShown"] as! Bool
        self.distanceShown = dict["distanceShown"] as! Bool
    }
}
