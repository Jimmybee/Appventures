//
//  UserSummaryViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4


class UserSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Constants {
        static let LoginViewController = "Login View Controller"
        static let CellName = "Cell"
        static let segueCreateNewAppventure = "Create New Appventure"
        static let segueEditAppventure = "Edit Appventure"
        static let CreateInteractive = "Create Interactive"
    }
    
    var ownedAppventures = [Appventure]()
    var compeletedAppventures = [Appventure]()

    @IBOutlet weak var imageLoadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableLoadSpinner: UIActivityIndicatorView!
      
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var profileImage: UIImageView!
    

    //MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CoreUser.checkLogin(true, vc: self) {
//            loadUserData()
        }
    }
    
    func saveLocalData () {
        
    }
 

    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }

    func updateUI() {
//        userName.text = "\(user.firstName) \(user.lastName)"
        tableView.reloadData()
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    //MARK: Load User Data
    
    func fbGraphLoaded () {
        self.updateUI()
    }
    
    func updateImages() {
//        self.profileImage.image = user.profilePicture
        self.imageLoadSpinner.stopAnimating()

    }
    
    //MARK: Parse
    
    
    func updateTableWithQuery(_ objects: [AnyObject]) {
        self.ownedAppventures.removeAll()
//        for object in objects {
//            if let appventureName = object.objectForKey(Appventure.pfAppventure.pfTitle) as? String {
//                if let appventureLocate = object.objectForKey(Appventure.pfAppventure.pfCoordinate) as? PFGeoPoint {
//                    let appventurePFID = object.objectId!
//                    let appventure = Appventure(PFObjectID: appventurePFID, name: appventureName, geoPoint: appventureLocate)
//                    appventure.subtitle = object.objectForKey(Appventure.pfAppventure.pfSubtitle) as? String
//                    appventure.pfFile = object[Appventure.pfAppventure.pfAppventureImage] as? PFFile
//                    self.ownedAppventures.append(appventure)
//                }
//            }
//        }
        
        self.tableLoadSpinner.stopAnimating()
        self.tableView.reloadData()

    }

  
    
    //MARK: Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cavc = segue.destination as? CreateAppventureViewController {
            if segue.identifier == Constants.segueEditAppventure {
                if let tbCell = sender as? UITableViewCell {
                    if let row = tableView.indexPath(for: tbCell)!.row as Int! {
                        cavc.newAppventure = ownedAppventures[row]
                        cavc.appventureIndexRow = row
                    }
                }
            }
            cavc.delegate = self
        }
        
    }
    
    
    //MARK: Table functions
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            if let count = ownedAppventures.count as Int! {
                return count
            } else {
                return 1
            }
        } else  {
            if let count = compeletedAppventures.count as Int! {
                return count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellName) as UITableViewCell!
        
        let row = indexPath.row
        if segmentControl.selectedSegmentIndex == 0 {
            if let _ = ownedAppventures.count as Int! {
                cell?.textLabel?.text = ownedAppventures[row].title
            } else {
                cell?.textLabel?.text = "no appventures"

            }
        
        } else  {
            if let _ = compeletedAppventures.count as Int! {
                cell?.textLabel?.text = compeletedAppventures[row].title
            } else {
                cell?.textLabel?.text = "no appventures"
                
            }
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            let objectID = ownedAppventures[indexPath.row].pFObjectID
//            let query = PFQuery(className: Appventure.pfAppventure.pfClass)
//            query.getObjectInBackgroundWithId(objectID!) {
//                (object: PFObject?, error: NSError?) -> Void in
//                if error != nil {
//                    print(error)
//                } else {
//                    object?.deleteInBackground()
//                }
//            }
//
//            ownedAppventures.removeAtIndex(indexPath.row)
//            tableView.reloadData()
//        }
    }
    
}

extension UserSummaryViewController : CreateAppventureViewControllerDelegate {
    func appendNewAppventure(_ appventure: Appventure, indexRow: Int?) {
        if let row = indexRow as Int! {
            ownedAppventures[row] = appventure
        } else {
            ownedAppventures.append(appventure)
        }
        
        tableView.reloadData()

    }

    func reloadTable() {
        tableView.reloadData()

    }
}


extension UserSummaryViewController : ParseQueryHandler {
    
    
    func handleQueryResults(_ objects: [AnyObject]?, handlerCase: String?) {
//        if let isPFArray = objects as [PFObject]! {
//            for object in isPFArray {
//                let appventure = Appventure(object: object)
//                ParseFunc.loadImage(appventure)
//                self.ownedAppventures.append(appventure)
//            }
//        }
//        tableView.reloadData()
//        tableLoadSpinner.stopAnimating()
    }
}

extension UserSummaryViewController : UserDataHandler {
    func userFuncComplete(_ funcKey: String) {
        switch funcKey{
        case User.funcKeys.fbGraphLoaded:
            self.updateUI()
        case User.funcKeys.fbImageLoaded:
            self.updateImages()
            self.saveLocalData()
        case User.funcKeys.localDataLoaded:
            self.updateImages()
//            self.loadUserData()
        default: break
        }
    }
}
