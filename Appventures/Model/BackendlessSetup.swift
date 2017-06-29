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
     public var isLocation: Bool = false
     public var locationShown: Bool = false
     public var compassShown: Bool = false
     public var distanceShown: Bool = false
     public var objectId: String!
     public var stepTypeRaw: Int16 = 0
    
    override init() {
        super.init()
    }
    
    init(setup: StepSetup) {
        self.objectId = setup.backendlessId
        self.textClue = setup.textClue
        self.soundClue = setup.soundClue
        self.pictureClue = setup.pictureClue
        self.isLocation  = setup.isLocation
        self.locationShown = setup.locationShown
        self.compassShown = setup.compassShown
        self.distanceShown = setup.distanceShown
        self.stepTypeRaw = setup.stepTypeRaw
    }
}
