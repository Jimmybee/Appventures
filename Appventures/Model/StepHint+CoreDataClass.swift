//
//  StepHint+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 06/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


public class StepHint: NSManagedObject {
    
    struct CoreKeys {
        static let entityName = "StepHint"
    }
    
    convenience init (step: AppventureStep, hint: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        self.hint = hint
        self.step = step
    }
    
    convenience init(_ backendlesHint: BackendlessHint, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlesHint.objectId
        self.hint = backendlesHint.hint
        
    }
}
