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
    
    /// save an appventure to backend. Checks if objectId is nil as this is needed to pictureUrl
    class func save(appventure: Appventure, withImage: Bool, completion: @escaping () -> ()) {
        
        apiUploadGroup.enter()
        let backendlessAppventure = BackendlessAppventure(appventure: appventure)
        backendlessAppventure.save(completion: { (backendlessAppventure) in
            let appventureWithId = Appventure(backendlessAppventure: backendlessAppventure, persistent: true)
            appventureWithId.imageUrl = appventureWithId.imageUrl == appventure.imageUrl ? appventure.imageUrl : imageUrl(fromObjectId: appventureWithId.backendlessId!)

            
            if withImage == true {
                uploadImageAsync(url: appventureWithId.imageUrl, image: appventure.image, completion: { (imageUrl) in
                    print("File has been uploaded. File URL is - \(String(describing: imageUrl))")
//                    appventure.imageUrl = imageUrl
                })
            }
            
            for (index, step) in appventureWithId.appventureSteps.enumerated() {
                step.image = appventure.appventureSteps[index].image
                uploadImageAsync(objectId: step.backendlessId, image: step.image, completion: { (imageUrl) in
                    step.imageUrl = imageUrl
                    
                })
            }
            apiUploadGroup.leave()
            
            apiUploadGroup.notify(queue: .main) {
                backendlessAppventure.save(completion: { (fullySavedAppventure) in
                    CoreUser.user?.removeFromOwnedAppventures(appventure)
                    CoreUser.user?.addToOwnedAppventures(fullySavedAppventure)
                    AppDelegate.coreDataStack.saveContext(completion: nil)
                    completion()
                })
            }
            
        })
        

        
    }
    
    class func imageUrl(fromObjectId: String) -> String {
        let filename = String(Date().timeIntervalSince1970 * 100)
        return "myfiles/\(fromObjectId)/\(filename).jpg"
    }
    
    class func uploadImageAsync(url: String?, image: UIImage?, completion: @escaping (String?) -> ()) {
        print("\n============ Uploading files with the ASYNC API ============")
        guard  let image = image  else { return }
        
        let data = UIImagePNGRepresentation(image)

        apiUploadGroup.enter()
        BackendlessAppventure.backendless?.fileService.upload(
            url,
            content: data,
            overwrite:true,
            response: { ( uploadedFile ) in
                print("File has been uploaded. File URL is - \(String(describing: uploadedFile?.fileURL))")
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


