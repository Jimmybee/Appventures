//
//  BackendlessStep.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessStep : NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure.ofClass())
    
    public var objectId: String?
    public var stepNumber: Int16 = 0
    public var nameOrLocation: String?
    public var initialText: String?
    public var checkInProximity: Int16 = 0
    public var completionText:String?
    public var setup: BackendlessSetup?
    public var location: GeoPoint?
    public var freeHints: Int16 = 0
    public var hintPenalty: Int16 = 0
    public var answerHint:String?
    public var answerText: String?

    override init() {
        super.init()
    }
    
    init(step: AppventureStep) {
        self.objectId = step.backendlessId
        self.stepNumber = step.stepNumber
        self.nameOrLocation = step.nameOrLocation
        self.setup = BackendlessSetup(setup: step.setup)
        self.initialText = step.initialText
        self.completionText = step.completionText
        self.checkInProximity = step.checkInProximity
        self.hintPenalty = step.hintPenalty
        self.freeHints = step.freeHints
//        self.answerHint = step.answerHint.joined(separator: ",")
//        self.answerText = step.answerText.joined(separator: ",")
        
        if let location = step.location {
        self.location = GeoPoint.geoPoint(
            GEO_POINT(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            categories: ["Step"],
            metadata: ["Tag":"Great"]
            ) as? GeoPoint
        }
    }
    
    init(dict: Dictionary<String, Any>) {
        self.objectId = dict["objectId"] as? String
        self.stepNumber = dict["stepNumber"] as? Int16 ?? 0
        self.nameOrLocation = dict["nameOrLocation"] as? String
        self.initialText = dict["initialText"] as? String
        self.completionText = dict["completionText"] as? String
        self.checkInProximity = dict["checkInProximity"] as? Int16 ?? 0
        self.hintPenalty = dict["hintPenalty"] as? Int16 ?? 0
        self.freeHints = dict["freeHints"] as? Int16 ?? 0
        self.answerHint = dict["answerHint"] as? String
        self.answerText = dict["answerText"] as? String
        if let setupDict = dict["setup"] as? Dictionary<String, Any> {
            let setup = BackendlessSetup(dict: setupDict)
            self.setup = setup
        }
        self.location = dict["location"] as? GeoPoint
        
    }
    
    static func removeBy(id: String) {
        let dataStore = Backendless.sharedInstance().data.of(BackendlessStep.ofClass())
        dataStore?.removeID(id, response: { (response) in
            print(response ?? "removeResponse")
        }, error: { (fault) in
            print(fault ?? "removeResponse")
        })
    }
    
}
