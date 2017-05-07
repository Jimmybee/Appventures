//
//  AppventureStep+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


extension AppventureStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppventureStep> {
        return NSFetchRequest<AppventureStep>(entityName: "AppventureStep");
    }

    @NSManaged public var answerHint: [String]!
    @NSManaged public var answerText: [String]!
    @NSManaged public var appventurePFObjectID: String?
    @NSManaged public var checkInProximity: Int16
    @NSManaged public var completionText: String?
    @NSManaged public var freeHints: Int16
    @NSManaged public var hintPenalty: Int16
    @NSManaged public var image: UIImage?
    @NSManaged public var initialText: String?
    @NSManaged public var nameOrLocation: String?
    @NSManaged public var backendlessId: String?
    @NSManaged public var sound: Data?
    @NSManaged public var stepNumber: Int16
    @NSManaged public var location: CLLocation?
    @NSManaged public var appventure: Appventure?
    @NSManaged public var setup: StepSetup!
    
}
