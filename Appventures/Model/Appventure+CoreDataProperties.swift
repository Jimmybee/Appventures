//
//  Appventure+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Appventure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appventure> {
        return NSFetchRequest<Appventure>(entityName: "Appventure");
    }

    @NSManaged public var duration: Int64
    @NSManaged public var image: UIImage?
    @NSManaged public var imageUrl: String?
    @NSManaged public var tags: Set<String>!
    @NSManaged public var liveStatusNum: Int16
    @NSManaged public var backendlessId: String?
    @NSManaged public var startingLocationName: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var totalDistance: Double
    @NSManaged public var userID: String?
    @NSManaged public var steps: Set<AppventureStep>
    @NSManaged public var owner: CoreUser
    @NSManaged public var contributer: CoreUser
    @NSManaged public var buyer: CoreUser
    @NSManaged public var location: CLLocation
    @NSManaged public var startTime: String?
    @NSManaged public var endTime: String?


}

// MARK: Generated accessors for steps
extension Appventure {

    @objc(insertObject:inStepsAtIndex:)
    @NSManaged public func insertIntoSteps(_ value: AppventureStep, at idx: Int)

    @objc(removeObjectFromStepsAtIndex:)
    @NSManaged public func removeFromSteps(at idx: Int)

    @objc(insertSteps:atIndexes:)
    @NSManaged public func insertIntoSteps(_ values: [AppventureStep], at indexes: NSIndexSet)

    @objc(removeStepsAtIndexes:)
    @NSManaged public func removeFromSteps(at indexes: NSIndexSet)

    @objc(replaceObjectInStepsAtIndex:withObject:)
    @NSManaged public func replaceSteps(at idx: Int, with value: AppventureStep)

    @objc(replaceStepsAtIndexes:withSteps:)
    @NSManaged public func replaceSteps(at indexes: NSIndexSet, with values: [AppventureStep])

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: AppventureStep)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: AppventureStep)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSOrderedSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSOrderedSet)

}
