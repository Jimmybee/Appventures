//
//  AppventureStep.swift
//  MapPlay
//
//  Created by James Birtwell on 08/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
import CoreData


 extension AppventureStep {
    
    @nonobjc static var dataLoads = [String : Int]()

    
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
