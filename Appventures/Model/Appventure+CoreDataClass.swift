//
//  Appventure+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import Kingfisher

public class Appventure: NSManagedObject {
       
    static var currentAppventure: Appventure?
    var downloaded = true
    var liveStatus:LiveStatus {
            get { return LiveStatus(rawValue: self.liveStatusNum) ?? .inDevelopment }
            set { self.liveStatusNum = newValue.rawValue }
    }
    var appventureSteps: [AppventureStep] {
        get { return Array(steps).sorted(by: { $0.stepNumber < $1.stepNumber }) }
        set {
            print("*setting steps**")
        }
    }
    
    struct CoreKeys {
        static let entityName = "Appventure"
    }
    
    var saveImage = false
    
    var rating = 5
    
    
    /// init for a new appventure
    convenience init () {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        let coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.liveStatus = .inDevelopment
        self.duration = 0
        self.startTime = "12:00"
        self.endTime = "12:00"
        self.owner = CoreUser.user!
    }
    
    /// init for appventure using backendless API data
    convenience init (backendlessAppventure: BackendlessAppventure, persistent: Bool) {
        let context = persistent ? AppDelegate.coreDataStack.persistentContainer.viewContext : AppDelegate.coreDataStack.tempContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        self.startTime = backendlessAppventure.startTime
        self.endTime = backendlessAppventure.endTime
        self.themeOne = backendlessAppventure.themeOne
        self.themeTwo = backendlessAppventure.themeTwo
        self.imageUrl = backendlessAppventure.imageUrl
        self.backendlessId = backendlessAppventure.objectId
        self.title = backendlessAppventure.title
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        self.startingLocationName = backendlessAppventure.startingLocationName
        self.subtitle = backendlessAppventure.subtitle
        let geoPoint = backendlessAppventure.location
        self.location = CLLocation(latitude: geoPoint!.latitude as CLLocationDegrees, longitude: geoPoint!.longitude as CLLocationDegrees)
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        self.duration = backendlessAppventure.duration
        for backendlessStep in backendlessAppventure.steps {
            let step = AppventureStep(backendlessStep: backendlessStep, persistent: persistent)
            self.addToSteps(step)
        }
    }
    
    
    /// Delete from context
    func deleteAppventure() {
        BackendlessAppventure.removeBy(id: self.backendlessId ?? "")
        AppDelegate.coreDataStack.delete(object: self, completion: nil)
    }
    
    
    //MARK: Load Image
    func loadImageFor(cell: AppventureImageCell) {
        guard let stringUrl = self.imageUrl else { return }
        guard let url = URL(string: stringUrl) else { return }

        let resource = ImageResource(downloadURL: url)
        cell.appventureImage.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
            self.image = image
        }
    }
    
    func isValid() -> Bool {
        var valid = true
        
        if !CLLocationCoordinate2DIsValid(self.location.coordinate) { valid = false }
        if self.steps.count == 0 { valid = false }
//        if !(self.title?.characters.count > count?) { valid = false }
        return valid 
    }
      
}
