//
//  BackendlessSetup.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessHint: NSObject {
    
    public var hint: String!
    public var objectId: String!
    
    init(stepHint: StepHint) {
        self.objectId = stepHint.backendlessId
        self.hint = stepHint.hint
    }
    
    init(dict: Dictionary<String, Any>) {
        self.objectId = dict["objectId"] as? String
        self.hint = dict["hint"] as? String
    }
}
