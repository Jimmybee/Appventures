//
//  StepSetup+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension StepSetup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepSetup> {
        return NSFetchRequest<StepSetup>(entityName: "StepSetup");
    }

    @NSManaged public var textClue: Bool
    @NSManaged public var soundClue: Bool
    @NSManaged public var pictureClue: Bool
    @NSManaged public var checkIn: Bool
    @NSManaged public var isLocation: Bool
    @NSManaged public var locationShown: Bool
    @NSManaged public var compassShown: Bool
    @NSManaged public var distanceShown: Bool
    @NSManaged public var step: AppventureStep?
    @NSManaged public var backendlessId: String?

}
