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
    
    var stepType: StepType {
        get {
            return StepType(rawValue: stepTypeRaw) ?? StepType.checkIn
        }
        set {
            stepTypeRaw = newValue.rawValue
        }
    }
    
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
        self.stepTypeRaw = backendlesSetup.stepTypeRaw
        self.isLocation  = backendlesSetup.isLocation
        self.locationShown = backendlesSetup.locationShown
        self.compassShown = backendlesSetup.compassShown
        self.distanceShown = backendlesSetup.distanceShown

    }
    
}

enum StepType: Int16 {
    case checkIn, written, multipleChoice
    
    var image: UIImage? {
        switch self {
        case .checkIn:
            return ImageNames.VcCreate.checkIn
        case .written:
            return ImageNames.VcCreate.pencilHighlight
        case .multipleChoice:
            return ImageNames.VcCreate.pencilHighlight

        }
    }
}
