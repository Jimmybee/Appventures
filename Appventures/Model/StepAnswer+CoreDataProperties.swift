//
//  StepAnswer+CoreDataProperties.swift
//  Appventures
//
//  Created by James Birtwell on 08/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


extension StepAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepAnswer> {
        return NSFetchRequest<StepAnswer>(entityName: "StepAnswer");
    }

    @NSManaged public var correct: Bool
    @NSManaged public var answer: String?
    @NSManaged public var backendlessId: String?
    @NSManaged public var step: AppventureStep?

}
