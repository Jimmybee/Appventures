//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 17/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

typealias ServiceNewResponse = (AnyObject?, AnyObject?) -> ()

class BackendlessAppventure: NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure.ofClass())

    public var objectId: String?
    public var ownerId: String?
    public var imageUrl: String?
    public var duration: Int64 = 3600
    public var themeOne: String?
    public var themeTwo: String?
    public var liveStatusNum: Int16 = 0
    public var startingLocationName: String?
    public var subtitle: String?
    public var title: String?
    public var startTime: String?
    public var endTime: String?
    public var totalDistance: Double? = 0
    public var location: GeoPoint?
    public var steps: [BackendlessStep] = []
    
    override init() {
        super.init()
    }
    
    init(appventure: Appventure) {
        super.init()
        print(CoreUser.user?.backendlessId ?? "nill user id")
        self.ownerId = CoreUser.user?.backendlessId
        self.duration = appventure.duration
        self.startTime = appventure.startTime
        self.endTime = appventure.endTime
        self.imageUrl = appventure.imageUrl
        self.startingLocationName  = appventure.startingLocationName
        self.themeOne = appventure.themeOne
        self.themeTwo = appventure.themeTwo
        self.liveStatusNum = appventure.liveStatusNum
        self.objectId = appventure.backendlessId
        self.title = appventure.title!
        self.subtitle = appventure.subtitle
        self.totalDistance = appventure.totalDistance
        self.location = GeoPoint.geoPoint(
            GEO_POINT(latitude: appventure.location.coordinate.latitude, longitude: appventure.location.coordinate.longitude),
            categories: ["Appventure"],
            metadata: ["Tag":"Great"]
            ) as? GeoPoint
        for step in appventure.steps {
            let backendlessStep = BackendlessStep(step: step)
            self.steps.append(backendlessStep)
        }
    }
    
    private func save(completion: @escaping (BackendlessAppventure) -> ()) {
        BackendlessAppventure.dataStore?.save(self, response: { (returnObject) in
            let obj = returnObject as! BackendlessAppventure
            completion(obj)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    static let apiUploadGroup = DispatchGroup()
    
    /// save an appventure to backend.
    /// Saved apppventure now definietly has backendlessId, so assign
    /// Make sure backendlessAppventure has the same url or assign a new one.
    class func save(appventure: Appventure, completion: @escaping () -> ()) {
        
        var appventureWithId: Appventure!
        apiUploadGroup.enter()
        let backendlessAppventure = BackendlessAppventure(appventure: appventure)
        backendlessAppventure.save(completion: { (backendlessAppventure) in
             appventureWithId = Appventure(backendlessAppventure: backendlessAppventure, persistent: true)
            if appventure.requiresImageSave {
                appventureWithId.image = appventure.image
                let imageString = self.imageUrl(fromObjectId: appventureWithId.backendlessId!)
                if  let image = appventureWithId.image   {
                    let data = UIImagePNGRepresentation(image)
                    uploadImageAsync(url: imageString, data: data, completion: { (imageUrl) in
                        appventureWithId.imageUrl = imageUrl
                    })
                }
            }
            
            for (index, step) in appventureWithId.appventureSteps.enumerated() {
                let oldStep = appventure.appventureSteps[index]
                if oldStep.image != nil {
                    if appventure.appventureSteps[index].requiresImageSave {
                        step.image = oldStep.image
                        let imageString = self.imageUrl(fromObjectId: step.backendlessId!)
                        if  let image = step.image   {
                            let data = UIImagePNGRepresentation(image)
                            uploadImageAsync(url: imageString, data: data, completion: { (imageUrl) in
                                step.imageUrl = imageUrl
                            })
                        }
                    }
                }
                
                if oldStep.sound != nil {
                    if appventure.appventureSteps[index].requiresSoundSave {
                        step.sound = oldStep.sound
                        let soundString = self.soundUrl(fromObjectId: step.backendlessId!)
                        if  let sound = step.sound   {
                            uploadImageAsync(url: soundString, data: sound, completion: { (fileUrl) in
                                step.soundUrl = fileUrl
                            })
                        }
                    }
                }
            }
            apiUploadGroup.leave()
            
            
        })
        
        apiUploadGroup.notify(queue: .main) {
            let backendlessAppventure = BackendlessAppventure(appventure: appventureWithId)
            backendlessAppventure.save(completion: { (fullySavedAppventure) in
                CoreUser.user?.removeFromOwnedAppventures(appventure)
                CoreUser.user?.addToOwnedAppventures(appventureWithId)
                AppDelegate.coreDataStack.saveContext(completion: nil)
                completion()
            })
        }

        
    }
    
    class func soundUrl(fromObjectId: String) -> String {
        let filename = String(Int(Date().timeIntervalSince1970 * 100))
        return "myfiles/\(fromObjectId)/\(filename).m4a"
    }
    
    class func imageUrl(fromObjectId: String) -> String {
        let filename = String(Int(Date().timeIntervalSince1970 * 100))
        return "myfiles/\(fromObjectId)/\(filename).jpg"
    }
    
    class func uploadImageAsync(url: String?, data: Data?, completion: @escaping (String?) -> ()) {
        apiUploadGroup.enter()
        BackendlessAppventure.backendless?.fileService.upload(
            url,
            content: data,
            overwrite:true,
            response: { ( uploadedFile ) in
                completion(uploadedFile?.fileURL)
                apiUploadGroup.leave()
        },
            error: { ( fault ) in
                print("Server reported an error: \(String(describing: fault))")
        })
    }
    
    
    class func loadBackendlessAppventures(persistent: Bool, dataQuery: BackendlessDataQuery, completion: @escaping ServiceNewResponse) {
        let queryOptions = QueryOptions()
        queryOptions.relationsDepth = 2
        dataQuery.queryOptions = queryOptions
        var appventures = [Appventure]()
        let dataStore = Backendless.sharedInstance().data.of(BackendlessAppventure.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            let page1 = collection!.getCurrentPage()
            for obj in page1! {
                let backendlessAppventure = obj as! BackendlessAppventure
                let appventure = Appventure(backendlessAppventure: backendlessAppventure, persistent: persistent)
                appventures.append(appventure)
            }
            completion(appventures as AnyObject?, nil)
        }, error: { (fault) in
            print("Server reported an error: \(String(describing: fault))")
            completion(nil, fault)
        })
    }
    
    class func removeBy(id: String) {
        BackendlessAppventure.dataStore?.removeID(id, response: { (response) in
            print(response ?? "removeResponse")
        }, error: { (fault) in
            print(fault ?? "removeFault")
        })
    }

}


