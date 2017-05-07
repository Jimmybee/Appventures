//
//  AppventureStep.swift
//  MapPlay
//
//  Created by James Birtwell on 08/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
//import Parse
import CoreData


 extension AppventureStep {
    
    @nonobjc static var dataLoads = [String : Int]()
    
    func updateCoreDataBridges() {
      //  if let image = self.image {self.imageData = UIImagePNGRepresentation(image)}
       // self.setupObj = self.setup as NSObject
      //  self.answerHintObj = self.answerHint as NSObject
      //  self.answerTextObj = self.answerText as NSObject
//        self.coordinateLon = self.coordinate.longitude
//        self.coordinateLat = self.coordinate.latitude
    }
    
    
    
    func setValuesForObject() {
       // self.setup = self.setupObj! as! [String : Bool]
      //  self.answerHint = self.answerHintObj! as! [String]
      //  self.answerText = self.answerTextObj! as! [String]
//        self.coordinate = CLLocationCoordinate2DMake(self.coordinateLat, self.coordinateLon)
      //  if let data = self.imageData {self.image = UIImage(data: data as Data)}
    }

//     var PFObjectID: String? = ""//Given at point of save/load
//     var AppventurePFObjectID: String?  = "" //Given at point of save/load
    
     //Required for valid save
//     var stepNumber: Int? // Given on creation
//     var nameOrLocation = "set location"    

    
     class func convertStringToDictionary(_ text: String) -> [String:Bool]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                if let dict = json as! [String: Bool]! {
                    return dict
                }
            } catch {
                print("failedToLoadDict")
            }
            
        }
        
        return nil
        
    }
    
     func convertDictToJson(_ dict: [String: Bool]) -> String? {
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: dict , options: JSONSerialization.WritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData, encoding: String.Encoding.ascii.rawValue) as! String
            return String(theJSONText)
            
        } catch {
            print("failedToCreateString")
            return nil
        }
    }


}

//copy init
//extension AppventureStep {
    
//    convenience init(step: AppventureStep) {
//        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
//        self.init(entity: entity!, insertInto: nil)
//        
//        self.pFObjectID = step.pFObjectID
//        self.appventurePFObjectID = step.appventurePFObjectID
//        self.nameOrLocation = step.nameOrLocation
//        self.locationSubtitle = step.locationSubtitle
//        self.initialText = step.initialText
//        self.answerText = step.answerText
//        self.answerHint = step.answerHint
//        self.answerFormatHint = step.answerFormatHint
//        self.completionText = step.completionText
//        self.stepNumber = step.stepNumber
//        self.freeHints = step.freeHints
//        self.hintPenalty = step.hintPenalty
//        self.saved =  step.saved
//        self.image = step.image
//        self.imagePFFile = step.imagePFFile
//        self.soundPFFile = step.soundPFFile
//        self.sound = step.sound
//        self.setup = step.setup
//        self.coordinate = step.coordinate
//        self.checkInProximity = step.checkInProximity
//    }
    

