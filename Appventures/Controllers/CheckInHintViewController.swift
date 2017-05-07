//
//  CheckInHintViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class CheckInHintViewController: UIViewController {
    
    lazy var stepLocationName: String? = ""
    lazy var stepCoordinate = kCLLocationCoordinate2DInvalid
    lazy var lastLocation = CLLocation()
    lazy var stepDistance: Int16 = 0
    var answerHint = [String]()
    var hintsRecieved: Int16 = 0
    
    
    @IBOutlet weak var hintButton: UIButton!
    
    var placePicker: GMSPlacePicker?

    
//    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var checkIn: UIButton!
//    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkIn.layer.borderWidth = 2.0
//        checkIn.layer.borderColor = UIColor.whiteColor().CGColor
//        hintButton.layer.borderWidth = 2.0
//        hintButton.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
    }
    
    func setup () {
        warningLabel.text = ""
         hintsRecieved = 0

    }

    //MARK: Check In Method
    func checkIne() {
        var center: CLLocationCoordinate2D?
        
        if let currentCoordinate = lastLocation.coordinate as CLLocationCoordinate2D! {
            center = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude)
        } else {
            center = CLLocationCoordinate2DMake(0, 0)
        }
        
        let northEast = CLLocationCoordinate2DMake(center!.latitude + 0.001, center!.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center!.latitude - 0.001, center!.longitude - 0.001)
        
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlace(callback: {place, error in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                if place.name == self.stepLocationName {
                    let placeCenter = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    let distanceToPlace = placeCenter.distance(from: self.lastLocation)
                    print(self.lastLocation.coordinate)
                    print(placeCenter.coordinate)
                    print(distanceToPlace)
                    if self.stepDistance == 0 ||  distanceToPlace < Double(self.stepDistance) {
                        if let pvc = self.parent as? StepViewController {
                            pvc.stepComplete()
                        }
                    } else {
                        self.warningLabel.text = "Move closer to the destination to proceed."
                    }
                    
                } else {
                    print(self.stepLocationName! )
                    self.warningLabel.text = "Incorrect place selected. Try Again."
                }
            } else {
                print("No place selected")
            }
        })
        
    }
    
    
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
