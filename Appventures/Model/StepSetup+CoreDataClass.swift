//
//  StepSetup+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

public class StepSetup: NSManagedObject {
    
    struct CoreKeys {
        static let entityName = "StepSetup"
    }
    
    convenience init (step: AppventureStep, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.step = step
    }
    
    convenience init(backendlesSetup: BackendlessSetup, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlesSetup.objectId
        self.textClue = backendlesSetup.textClue
        self.soundClue = backendlesSetup.soundClue
        self.pictureClue = backendlesSetup.pictureClue
        self.checkIn = backendlesSetup.checkIn
        self.isLocation  = backendlesSetup.isLocation
        self.locationShown = backendlesSetup.locationShown
        self.compassShown = backendlesSetup.compassShown
        self.distanceShown = backendlesSetup.distanceShown

    }
    
}
