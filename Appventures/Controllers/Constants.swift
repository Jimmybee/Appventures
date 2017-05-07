//
//  Constants.swift
//  EA - Clues
//
//  Created by James Birtwell on 28/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

struct Colors {
    
    static let purple = UIColor(red:0.54, green:0.25, blue:0.46, alpha:1.0)

    static let brightBlue = UIColor(hue: 233/360, saturation: 100/100, brightness: 100/100, alpha: 1.0) /* #001dff */
    static let midBlue = UIColor(hue: 233/360, saturation: 72/100, brightness: 100/100, alpha: 1.0) /* #475cff */
    static let fadedBlue = UIColor(hue: 233/360, saturation: 48/100, brightness: 100/100, alpha: 1.0) /* #8492ff */
    
    static let brightTurquoise = UIColor(hue: 163/360, saturation: 100/100, brightness: 100/100, alpha: 1.0) /* #00ffb6 */
    static let midTurquoise = UIColor(hue: 163/360, saturation: 72/100, brightness: 100/100, alpha: 1.0) /* #47ffca */
    static let fadedTurquoise = UIColor(hue: 163/360, saturation: 48/100, brightness: 100/100, alpha: 1.0) /* #84ffdc */
    
    static let brightPurple = UIColor(hue: 312/360, saturation: 100/100, brightness: 100/100, alpha: 1.0) /* #ff00cb */
    static let midPurple = UIColor(hue: 312/360, saturation: 72/100, brightness: 100/100, alpha: 1.0) /* #ff47da */
    static let fadedPurple = UIColor(hue: 312/360, saturation: 48/100, brightness: 100/100, alpha: 1.0) /* #ff84e6 */
    
    static let brightGreen = UIColor(hue: 120/360, saturation: 90/100, brightness: 74/100, alpha: 1.0) /* #12bc12 */
    static let midGreen = UIColor(hue: 120/360, saturation: 65/100, brightness: 100/100, alpha: 1.0) /* #59ff59 */
    static let lightGreen = UIColor(hue: 120/360, saturation: 30/100, brightness: 100/100, alpha: 1.0) /* #b2ffb2 */



    
}

struct  Colours {
    static let myRed = UIColor(red: 255/255, green: 58/255, blue: 33/255, alpha: 1.0)
    static let myYellow = UIColor(red: 255/255, green: 209/255, blue: 43/255, alpha: 1.0)
    static let myBlue = UIColor(red: 76/255, green: 115/255, blue: 255/255, alpha: 1.0)
    static let myGreen = UIColor(red: 23/255, green: 183/255, blue: 45/255, alpha: 1.0)
}

struct RTFs {
    static let privacyPolicy = "Appventure Privacy Policy"
    static let howToPlay = "How to Play"
    static let choosingAdventure = "Choosing Adventure"
    static let makingAnAdventure = "Making An Adventure"
}

struct Notifications {
    static let reloadCatalogue = "reloadCatalogue"
}

let dataLoadedNotification = "dataLoadedNotification"
let skipLoginNotification = "skipLoginNotification"
let fbGraphLoadNotification = "fbGraphLoadNotification"
let fbImageLoadNotification = "fbImageLoadNotification"
let fbLoginParameters = ["public_profile", "email", "user_friends"]

let tutorialSeenNSDefault = "seenTutorial"

struct Storyboards {
    static let LaunchAppventure = "LaunchAppventure"
}

struct ViewControllerIds {
    static let Step = "StepViewController"
}
