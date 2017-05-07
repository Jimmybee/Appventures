//
//  StepAnswer+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 06/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

public class StepAnswer: NSManagedObject {

    struct CoreKeys {
        static let entityName = "StepAnswer"
    }
    
    convenience init (step: AppventureStep, answer: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        self.answer = answer
        self.step = step
    }
    
    convenience init(_ backendlesAnswer: BackendlessAnswer, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlesAnswer.objectId
        self.answer = backendlesAnswer.answer

    }
}
