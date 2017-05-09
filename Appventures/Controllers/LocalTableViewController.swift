//
//  Alt1LocalTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import CoreLocation
import FBSDKCoreKit
import SwiftyJSON

class LocalTableViewController: BaseTableViewController{
    
    var publicAppventuresMessage = "There are no adventures available on our servers at the moment."
    var friendsAppventuresMessage = "There are no adventures that your friends have shared with you."
    
    let firstLaunchKey = "firstLaunch"
    let howToVC = "HowToVC"
    let liveAppventures = "liveAppventures"
    let LocalAppventures = "LocalAppventures"
    
    struct StoryboardNames {
        static let TextCellID = "TextCell"
        static let startupLogin = "startupLogin"
    }
    
    let locationManager = CLLocationManager()
    var publicAppventures = [Appventure]()
    var searchController = UISearchController()
    var mainTabController: MainTabBarController!
    
    @IBOutlet weak var localPublicControl: UISegmentedControl!
    
    //Don't neeed
    var lastLocation: CLLocationCoordinate2D?
    var filter = Filter()
    var refreshing = false
    
    @IBOutlet weak var refreshSpinner: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        setupTableView()

        if let mtvc = self.tabBarController as? MainTabBarController {
            mainTabController = mtvc
            mtvc.stdFrame  = self.tabBarController?.tabBar.frame
        }
        
        UserManager.setupUser(completion: setupComplete)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HelperFunctions.unhideTabBar(self)
    }
    
    private func setupComplete() {
        if CoreUser.user?.userType == .noLogin {
            self.performSegue(withIdentifier: StoryboardNames.startupLogin, sender: nil)
        } else {
           getBackendlessAppventure()
        }
    }
    
    //MARK: Actions
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        publicAppventures.removeAll()
        tableView.reloadData()
        getBackendlessAppventure()
//        locationManager.requestLocation()
    }
    
    @IBAction func localPublicChange(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to appventure details
        if segue.identifier == "Alt1" {
            if let indexPath = sender as? IndexPath {
                if let aastvc = segue.destination as? AppventureStartViewController {
                    switch localPublicControl.selectedSegmentIndex {
                    case 0:
                        aastvc.appventure = CoreUser.user!.downloadedArray[indexPath.row]
                    case 1:
                        aastvc.appventure = publicAppventures[indexPath.row]
                    default:
                        break
                    }
                }
            }
        }
        
        if let lvc = segue.destination as? LoginViewController {
            lvc.delegate = self
        }
    }
    
    func checkFirstLaunch() {
        let defaults = UserDefaults.standard
        print(defaults.bool(forKey: firstLaunchKey))
        if defaults.bool(forKey: firstLaunchKey) == false {
            let storyBoard = UIStoryboard(name: "LaunchAppventure", bundle:nil)
            if let htvc = storyBoard.instantiateViewController(withIdentifier: howToVC) as? HowToViewController {
                self.present(htvc, animated: true, completion: nil)
            }
        }
        defaults.set(false, forKey: firstLaunchKey)
    }

}

// MARK: - Table Delegate 

extension LocalTableViewController {
    
    func setupTableView() {
        tableView.register(UINib(nibName: ExploreAppventureCell.cellIdentifierNibName, bundle: nil), forCellReuseIdentifier: ExploreAppventureCell.cellIdentifierNibName)

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch localPublicControl.selectedSegmentIndex {
        case 0:
            if CoreUser.user!.downloadedArray.count > 0 {
//                self.tableView.separatorStyle = .none
                self.tableView.backgroundView = UIView()
//                self.tableView.backgroundView?.backgroundColor = .lightGray
                return 1
            } else {
//                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
            }
            return 0
        case 1:
            if self.publicAppventures.count > 0 {
//                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//                self.tableView.backgroundView?.backgroundColor = .lightGray
                return 1
            } else {
//                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
            }
            return 0
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch localPublicControl.selectedSegmentIndex {
        case 0:
            rows = CoreUser.user!.downloadedArray.count
        case 1:
            rows = publicAppventures.count
        default:
            break
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreAppventureCell.cellIdentifierNibName, for: indexPath) as! ExploreAppventureCell
        let row = indexPath.row
        switch localPublicControl.selectedSegmentIndex {
        case 0:
            cell.appventure = CoreUser.user!.downloadedArray[row]
        case 1:
            cell.appventure = publicAppventures[row]
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Alt1", sender: indexPath)
    }

}


// MARK: - Location Manager Delegate

extension LocalTableViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        print("\(CLLocationManager.authorizationStatus())")
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first?.coordinate
        print(lastLocation ?? "no location")
        if refreshing == false {
            refreshing = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        publicAppventuresMessage = "Update location settings to get adventures in your area."
        let london = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275)
        if lastLocation == nil {lastLocation = london}
        
    }

}

// MARK: API Calls

extension LocalTableViewController {
    
    /// Move to backendless/model layer.
    func getBackendlessAppventure() {
        showProgressView()


        let dataQuery = BackendlessDataQuery()
        
        let liveWhere = "liveStatusNum = \(2)"
        let distanceWhere = "distance( 30.26715, -97.74306, location.latitude, location.longitude ) < mi(2000000)"
        
        dataQuery.whereClause = distanceWhere + " AND " + liveWhere
        
        BackendlessAppventure.loadBackendlessAppventures(persistent: false, dataQuery: dataQuery) { (response, fault) in
            self.hideProgressView()
            if fault == nil {
                guard let appventures = response as? [Appventure] else { return }
                self.publicAppventures = appventures
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
                self.setDownloadForAppventures()
            } else {
                //display message
            }
        }
    }
    
    private func setDownloadForAppventures() {
        let downloadedAppventures = CoreUser.user!.downloadedArray.flatMap( { $0.backendlessId })
        let unownedAppventures = publicAppventures.filter { (appventure) -> Bool in
            return !downloadedAppventures.contains(appventure.backendlessId!)
        }
        
        for appventure in unownedAppventures { appventure.downloaded = false }
        publicAppventures = unownedAppventures
    }
    
}

// MARK: - LoginViewController Delegate

extension LocalTableViewController : LoginViewControllerDelegate {
    func loginSucceed() {
        getBackendlessAppventure()
        print("login succeed")
    }
    
    func loginFailed() {
        print("failed login")
    }
}
