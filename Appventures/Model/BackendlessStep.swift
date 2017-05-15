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
    
    public var ownerId: String?
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
    public var hints = [BackendlessHint]()
    public var answers = [BackendlessAnswer]()

    override init() {
        super.init()
    }
    
    init(step: AppventureStep) {
        self.ownerId = CoreUser.user?.backendlessId
        self.objectId = step.backendlessId
        self.stepNumber = step.stepNumber
        self.nameOrLocation = step.nameOrLocation
        self.setup = BackendlessSetup(setup: step.setup)
        self.initialText = step.initialText
        self.completionText = step.completionText
        self.checkInProximity = step.checkInProximity
        self.hintPenalty = step.hintPenalty
        self.freeHints = step.freeHints
        self.answers = step.answers.map({ BackendlessAnswer(stepAnswer: $0)})
        self.hints = step.hints.map({ BackendlessHint(stepHint: $0)})

        if let location = step.location {
        self.location = GeoPoint.geoPoint(
            GEO_POINT(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            categories: ["Step"],
            metadata: ["Tag":"Great"]
            ) as? GeoPoint
        }
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
