//
//  AppventureStep+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

public class AppventureStep: NSManagedObject {
    @nonobjc static var appventureStepsHc = "appventureStepsHc"

    struct CoreKeys {
        @nonobjc static var entityName = "AppventureStep"
    }
    
    /// init for creating a step
    convenience init (appventure: Appventure) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.setup = StepSetup(step: self, context: context)
        self.answerHint = [String]()
        self.answerText = [String]()
        self.appventure = appventure
        let coordinate = kCLLocationCoordinate2DInvalid
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    /// init for creating a step from backendless API
    convenience init(backendlessStep: BackendlessStep, persistent: Bool) {
        let context = persistent ? AppDelegate.coreDataStack.persistentContainer.viewContext : AppDelegate.coreDataStack.tempContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlessStep.objectId
        self.nameOrLocation = backendlessStep.nameOrLocation
        self.stepNumber = backendlessStep.stepNumber
        self.initialText = backendlessStep.initialText
        self.completionText = backendlessStep.completionText
        self.checkInProximity = backendlessStep.checkInProximity
        self.hintPenalty = backendlessStep.hintPenalty
        self.freeHints = backendlessStep.freeHints
        self.answerHint = backendlessStep.answerHint?.splitStringToArray()
        self.answerText = backendlessStep.answerText?.splitStringToArray()
        let geoPoint = backendlessStep.location
        self.location = CLLocation(latitude: geoPoint!.latitude as Double, longitude: geoPoint!.longitude as Double)
        
        self.setup = StepSetup(backendlesSetup: backendlessStep.setup!, context: context)

    }
    
    
    var locationSubtitle = "set location"
    var saveSound = false
    var saveImage = false
    
    var answerFormatHint = ""

    
    func loadImage(completion: @escaping () -> ()?) {
        guard let objectId = self.backendlessId else { return }
        let url = "https://api.backendless.com/\(AppDelegate.APP_ID)/\(AppDelegate.VERSION_NUM)/files/myfiles/\(objectId)/image.jpg"
        Alamofire.request(url).response { response in
            guard let data = response.data else {return}
            guard let image = UIImage(data: data) else { return }
            self.image = image
            completion()
        }
    }
}
