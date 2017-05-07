
/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Bolts
//import Parse
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4
import GooglePlaces
import GoogleMaps
import CoreData


// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

struct Licensing {
    static let placesLicense = GMSPlacesClient.openSourceLicenseInfo()
    static let serviceLicense = GMSServices.openSourceLicenseInfo()
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
    //MARK: Backendless
    static let APP_ID = "975C9B70-4090-2D14-FFB1-BA95CB96F300"
    static let SECRET_KEY = "EEE8A10A-F7FC-955E-FF84-EE35BF400800"
    static let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    static var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        backendless?.initApp(AppDelegate.APP_ID, secret:AppDelegate.SECRET_KEY, version:AppDelegate.VERSION_NUM)
        backendless?.userService.setStayLoggedIn(true)

        //GMS
        
        GMSServices.provideAPIKey("AIzaSyDhyHZPC_SW2khLb02QqQ57fF5Wj68tjGs")
        GMSPlacesClient.provideAPIKey("AIzaSyDhyHZPC_SW2khLb02QqQ57fF5Wj68tjGs")
        
        return true
    }
    
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                           open: url,
                                                                           sourceApplication: sourceApplication,
                                                                           annotation: annotation)
        return true
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let installation = PFInstallation.currentInstallation()
//        installation!.setDeviceTokenFromData(deviceToken)
//        installation!.saveInBackground()
//        
//        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
//            if succeeded {
//                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
//            } else {
//                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
//            }
//        }
//    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        PFPush.handlePush(userInfo)
//        if application.applicationState == UIApplicationState.Inactive {
//            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
//        }
    }
    

}




