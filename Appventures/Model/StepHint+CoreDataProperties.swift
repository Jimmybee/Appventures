//
//  StepHint+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 06/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


extension StepHint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepHint> {
        return NSFetchRequest<StepHint>(entityName: "StepHint");
    }

    @NSManaged public var hint: String?
    @NSManaged public var backendlessId: String?
    @NSManaged public var step: AppventureStep?

}
