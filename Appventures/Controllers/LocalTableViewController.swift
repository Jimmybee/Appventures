//
//  Alt1LocalTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import SwiftyJSON
import Kingfisher


class LocalTableViewController: BaseViewController, ViewControllerHelpers {
    
    var fethcedAppventuresController: NSFetchedResultsController<Appventure>!
    
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
    
    private(set) lazy var catalogueBttn: SegmentButton = {
      let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.pink, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("CATALOGUE", for: .normal)
      return bttn
    }()
    
    private(set) lazy var downloadedBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.pink, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("DOWNLOADED", for: .normal)
        return bttn
    }()
    
    private(set) lazy var filterView: FilterView = {
        let bundle = Bundle(for: FilterView.self)
        let nib = bundle.loadNibNamed(FilterView.nib, owner: self, options: nil)
        let view = nib?.first as? FilterView
        return view!
    }()
    
    var animatedControl = AnimatedSegmentControl()
    
    var filterOpen = false
    var attachedToTop: NSLayoutConstraint!
    var attachedToBottom: NSLayoutConstraint!
    
    //Don't need - figure out
    var lastLocation: CLLocationCoordinate2D?
    var refreshing = false
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var refreshSpinner: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let managedObjectContext = AppDelegate.coreDataStack.persistentContainer.viewContext
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext)

        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()

        setupLocationManager()
        setupTableView()
        setupFilterView()

        if let mtvc = self.tabBarController as? MainTabBarController {
            mainTabController = mtvc
            mtvc.stdFrame  = self.tabBarController?.tabBar.frame
        }
        
        UserManager.setupUser(completion: setupComplete)
        
        animatedControl = AnimatedSegmentControl(bttns: [downloadedBttn, catalogueBttn], delegate: self)
        animatedControl.backgroundColor = .white
        animatedControl.selectedButton = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HelperFunctions.unhideTabBar(self)

        print(reachability.isConnectedToNetwork)
        do {
            try fethcedAppventuresController?.performFetch()
        } catch {
            print("An error occurred")
        }
        
        tableView.reloadData()

    }
    
    private func setupComplete() {
        if CoreUser.user?.userType == .noLogin {
            self.performSegue(withIdentifier: StoryboardNames.startupLogin, sender: nil)
        } else {
           createController()
           getBackendlessAppventure()
        }
    }
    
    var filterHeight: CGFloat!
    var filterWidth: CGFloat!
    var filterX: CGFloat!
    var filterOpenY: CGFloat!
    var filterClosedY: CGFloat!
   
    
    private func setupFilterView() {
        self.view.addSubview(filterView)
        
        filterHeight = tableView.frame.size.height
        filterWidth = tableView.frame.size.width
        filterClosedY = tableView.frame.origin.y - filterHeight
        filterOpenY = tableView.frame.origin.y - 36
        filterX = tableView.frame.origin.x
        filterView.frame = CGRect(x: filterX, y: filterClosedY, width: filterWidth, height: filterHeight)
        
        filterView.setupCollectionView()
    }

    func createController() {
        guard let context = CoreUser.user?.managedObjectContext else { return }
        
        let primarySortDescriptor = NSSortDescriptor(key: "liveStatusNum", ascending: true)
        let fetch:NSFetchRequest<Appventure> = Appventure.fetchRequest()
        
        fetch.sortDescriptors = [primarySortDescriptor]
        fetch.predicate = NSPredicate(format: "buyer == %@", CoreUser.user!)
        
        fethcedAppventuresController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fethcedAppventuresController.delegate = self
        do {
            try fethcedAppventuresController.performFetch()
        } catch {
            print("An error occurred")
        }
        
    }
    
    //MARK: Actions
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        publicAppventures.removeAll()
        tableView.reloadData()
        getBackendlessAppventure()
//        locationManager.requestLocation()
    }
    
    @IBAction func filterBttnPressed(_ sender: Any) {
        
        switch filterOpen {
        case false:
            UIView.animate(withDuration: 0.3, animations: {
                self.filterView.frame = CGRect(x: self.filterX, y: self.filterOpenY, width: self.filterWidth, height: self.filterHeight)
            }, completion: nil)
        case true:
            UIView.animate(withDuration: 0.3, animations: {
                self.filterView.frame = CGRect(x: self.filterX, y: self.filterClosedY, width: self.filterWidth, height: self.filterHeight)
            }, completion: { (complete) in
                self.getBackendlessAppventure()
            })
        }

    
        filterOpen = !filterOpen
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to appventure details
        if segue.identifier == "Alt1" {
            if let indexPath = sender as? IndexPath {
                if let aastvc = segue.destination as? AppventureStartViewController {
                    switch animatedControl.selectedButton {
                    case 0:
                        aastvc.appventure = fethcedAppventuresController.object(at: indexPath)
                        aastvc.delegate = self
                        aastvc.index = indexPath.row
                    case 1:
                        aastvc.appventure = publicAppventures[indexPath.row]
                        aastvc.delegate = self
                        aastvc.index = indexPath.row
                    default:
                        break
                    }
                }
            }
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

extension LocalTableViewController: UITableViewDelegate, UITableViewDataSource    {
    
    func setupTableView() {
        tableView.register(UINib(nibName: ExploreAppventureCell.cellIdentifierNibName, bundle: nil), forCellReuseIdentifier: ExploreAppventureCell.cellIdentifierNibName)

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        switch animatedControl.selectedButton {
        case 0:
            if CoreUser.user!.downloaded?.count == 0 {
//                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
                return 1
            }
        case 1:
            if self.publicAppventures.count == 0 {
//                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
                return 1
            }
        default:
            return 1
        }
        
        tableView.backgroundView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundView?.backgroundColor = UIColor(red:0.93, green:0.92, blue:0.92, alpha:1.0)
        
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch animatedControl.selectedButton {
        case 0:
            rows = fethcedAppventuresController?.fetchedObjects?.count ?? 0
        case 1:
            rows = publicAppventures.count
        default:
            break
        }
        return rows
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreAppventureCell.cellIdentifierNibName, for: indexPath) as! ExploreAppventureCell
        let row = indexPath.row
        switch animatedControl.selectedButton {
        case 0:
            cell.appventure = fethcedAppventuresController.object(at: indexPath)
        case 1:
            cell.appventure = publicAppventures[row]
        default:
            break
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Alt1", sender: indexPath)
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return animatedControl
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


//MARK: - AnimatedSegmentControlDelegate
extension LocalTableViewController: AnimatedSegmentControlDelegate {
    
    func updatedButton(index: Int) {
        self.tableView.reloadData()
    }
    
    
}

// MARK: API Calls

extension LocalTableViewController {
    
    /// Move to backendless/model layer.
    func getBackendlessAppventure() {
        showProgressView()
        let dataQuery = BackendlessDataQuery()
//        let liveWhere = "liveStatusNum = \(LiveStatus.live.rawValue)"
        let inDevelopment = "liveStatusNum  = \(2)"

        let distanceWhere = "distance( 30.26715, -97.74306, location.latitude, location.longitude ) < mi(2000000)"
        dataQuery.whereClause = distanceWhere + " AND " + inDevelopment + filterClause()
        print(distanceWhere + " AND " + inDevelopment + filterClause())

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
    
    fileprivate func filterClause() -> String {
        if filterView.activeFilters.count == 0 { return "" }
        let themOnes = filterView.activeFilters.map({ "themeOne = '\($0.rawValue)'"}).joined(separator: " OR ")
        let themeTwos = filterView.activeFilters.map({ "themeTwo = '\($0.rawValue)'"}).joined(separator: " OR ")
        let themeFilter = " AND (" + themOnes + " OR " + themeTwos + ")"
        return themeFilter
    }
    
    private func setDownloadForAppventures() {
        let downloadedAppventures = fethcedAppventuresController?.fetchedObjects
        
        let ids = downloadedAppventures?.flatMap( { $0.backendlessId }) ?? [""]
        let unownedAppventures = publicAppventures.filter { (appventure) -> Bool in
            return !ids.contains(appventure.backendlessId!)
        }
        for appventure in unownedAppventures { appventure.downloaded = false }
        publicAppventures = unownedAppventures
    }
    
}

// MARK: - managedObjectContextDidSave

extension LocalTableViewController  {
    func managedObjectContextDidSave(notification: NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            if let user = inserts.first as? CoreUser {
                createController()
                getBackendlessAppventure()
            }
            print("--- INSERTS ---")
            print(inserts)
            print("+++++++++++++++")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> , updates.count > 0 {
            print("--- UPDATES ---")
            for update in updates {
                print(update.changedValues())
            }
            print("+++++++++++++++")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> , deletes.count > 0 {
            print("--- DELETES ---")
            print(deletes)
            print("+++++++++++++++")
        }
    }
}


//MARK: - Fetched Results Delegate

extension LocalTableViewController: NSFetchedResultsControllerDelegate {
    // MARK: NSFetchedResultsControllerDelegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        print("type \(type)")
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let insertIndexPath = newIndexPath {
         //       self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
            }
        case NSFetchedResultsChangeType.delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
        case NSFetchedResultsChangeType.update:
            if let updateIndexPath = indexPath {
                
            }
        case NSFetchedResultsChangeType.move:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}


// MARK: - Appventure Start Delegate

extension LocalTableViewController: AppventureStartDelegate {
    
    func removedJustDownloaded(atIndex: Int) {
        publicAppventures.remove(at: atIndex)
        tableView.reloadData()
    }
}

