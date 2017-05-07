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

public class Appventure: NSManagedObject {
   
    var pfFile: AnyObject?
    
    static var currentAppventure: Appventure?
    var downloaded = true
    var liveStatus:LiveStatus {
            get { return LiveStatus(rawValue: self.liveStatusNum) ?? .inDevelopment }
            set { self.liveStatusNum = newValue.rawValue }
    }
    var appventureSteps: [AppventureStep] {
        get { return Array(steps).sorted(by: { $0.stepNumber < $1.stepNumber }) }
        set { print("*setting steps**")}
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
        self.tags = Set<String>()
        self.owner = CoreUser.user!
    }
    
    /// init for appventure using backendless API data
    convenience init (backendlessAppventure: BackendlessAppventure, persistent: Bool) {
        let context = persistent ? AppDelegate.coreDataStack.persistentContainer.viewContext : AppDelegate.coreDataStack.tempContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        self.startTime = backendlessAppventure.startTime
        self.endTime = backendlessAppventure.endTime
        if let tagArray = backendlessAppventure.tags?.splitStringToArray() {
            self.tags = Set(tagArray)
        }
        self.imageUrl = backendlessAppventure.imageUrl
        self.backendlessId = backendlessAppventure.objectId
        self.title = backendlessAppventure.title
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        self.startingLocationName = backendlessAppventure.startingLocationName
        self.subtitle = backendlessAppventure.subtitle
        let geoPoint = backendlessAppventure.location
        self.location = CLLocation(latitude: geoPoint!.latitude as Double, longitude: geoPoint!.longitude as Double)
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        self.duration = backendlessAppventure.duration
        for backendlessStep in backendlessAppventure.steps {
            let step = AppventureStep(backendlessStep: backendlessStep, persistent: persistent)
            self.addToSteps(step)
        }
    }
    
    //Save methods
    
    func downloadAndSaveToCoreData (_ handler: () -> ()) {
        
//        CoreUser.user.owned
    }
    
    //Delete from context
    func deleteAppventure() {
//        self.deleteAppventureFromBackend()
        AppDelegate.coreDataStack.delete(object: self, completion: nil)
    }
    
    
    //MARK: Load Image
    func loadImageFor(cell: AppventureImageCell) {
        print("loading Image")
        loadImage(completion: {
            cell.appventureImage.image = self.image
            UIView.animate(withDuration: 0.3, animations: {
                cell.appventureImage.alpha = 1
            })
            cell.setNeedsDisplay()
        })
        
    }
    
    func loadImage(completion: ((Void) -> (Void))?) {
        guard let imageUrl = self.imageUrl else { return }
        Alamofire.request(imageUrl).response { response in
            guard let data = response.data,
             let image = UIImage(data: data) else { return }
            self.image = image
            guard let function = completion else { return }
            function()
        }
    }
    
}
