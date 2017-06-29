//
//  ProfileTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class MakerHomeViewController: BaseTableViewController {
    
    let UserAppventures = "UserAppventure"
    
    var fethcedAppventuresController: NSFetchedResultsController<Appventure>!

    
    struct Constants {
        static let CellName = "Cell"
        static let segueCreateNewAppventure = "Create New Appventure"
        static let segueEditAppventure = "Edit Appventure"
        static let segueSettings = "Settings"
    }
    
    private(set) lazy var createdBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.purple, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("CREATED", for: .normal)
        return bttn
    }()
    
    private(set) lazy var friendsBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.purple, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("FRIENDS", for: .normal)
        return bttn
    }()
    
    
    var animatedControl = AnimatedSegmentControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CoreUser.checkLogin(false, vc: self) {
            if CoreUser.user!.ownedAppventures?.count == 0 {
                restoreAppventures()
            }
            if CoreUser.user!.grantedAppventures?.count == 0 {
                getSharedAppventures()
            }
        }
        createController()
        tableView.refreshControl?.tintColor = .white
        
        animatedControl = AnimatedSegmentControl(bttns: [createdBttn, friendsBttn], delegate: self)
        animatedControl.backgroundColor = .white
        animatedControl.selectedButton = 0
        animatedControl.selectView.backgroundColor = Colors.purple

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if CoreUser.checkLogin(false, vc: self) {
            tableView.reloadData()
            print("owned adevntures: \(CoreUser.user?.ownedAppventures?.count)")
        } else {
            let alert = UIAlertController(title: "Log In Required", message: "Log In to allow access to adventure maker.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.tabBarController?.selectedIndex = 1
        }))
        }
        
        HelperFunctions.unhideTabBar(self)
    }
    
    func createController() {
        guard let context = CoreUser.user?.managedObjectContext else { return }
        
        let primarySortDescriptor = NSSortDescriptor(key: "liveStatusNum", ascending: true)
        let fetch:NSFetchRequest<Appventure> = Appventure.fetchRequest()
        
        fetch.sortDescriptors = [primarySortDescriptor]
        fetch.predicate = NSPredicate(format: "owner == %@", CoreUser.user!)
        
        fethcedAppventuresController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fethcedAppventuresController.delegate = self
        do {
            try fethcedAppventuresController.performFetch()
        } catch {
            print("An error occurred")
        }
        
    }
    
    /// Query all appventures with user id & load all data and images
    func restoreAppventures() {
        let dataQuery = BackendlessDataQuery()
        let id = Backendless.sharedInstance().userService.currentUser.objectId
        dataQuery.whereClause = "ownerId = '\(id!)'"
        self.showProgressView()
        BackendlessAppventure.loadBackendlessAppventures(persistent: true, dataQuery: dataQuery) { (response, fault) in
            DispatchQueue.main.async {
                self.hideProgressView()
                guard let appventures = response as? [Appventure] else { return }
                let orderedSet = NSOrderedSet(array: appventures)
                CoreUser.user?.addToOwnedAppventures(orderedSet)
                AppDelegate.coreDataStack.saveContext(completion: nil)
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func getSharedAppventures() {
        SharedAdventure.getGrantedSharedAppventures(shareeFbId: CoreUser.user!.facebookId!) { response in
            if let appventures = response {
                let set = NSOrderedSet(array: appventures)
                CoreUser.user?.addToGrantedAppventures(set)
                AppDelegate.coreDataStack.saveContext(completion: nil)
            }
        }
    }
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        CoreUser.user?.ownedAppventures?.forEach { AppDelegate.coreDataStack.delete(object: $0, completion: nil) }
        tableView.reloadData()
        restoreAppventures()
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cavc = segue.destination as? CreateAppventureViewController {
            if segue.identifier == Constants.segueEditAppventure {
                if let tbCell = sender as? UITableViewCell {
                    guard let indexPath = tableView.indexPath(for: tbCell) else { return }
                    cavc.newAppventure = fethcedAppventuresController.object(at: indexPath)
                    cavc.owner = animatedControl.selectedButton == 0 ? true : false
                }
            }
        }
    }

    //MARK: Table functions
    
    var tableMessage = ""
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fethcedAppventuresController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellName) as! AppventureMakerCell
        let appventure = fethcedAppventuresController.object(at: indexPath)
        cell.appventure = appventure
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
          confirmDeletePopup(indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return animatedControl
    }
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Appventure?", message: "Appventure data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteAppventureFromDB(indexPath)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAppventureFromDB (_ indexPath: IndexPath) {
        let appventure = fethcedAppventuresController.object(at: indexPath)
        if let backendlessId = appventure.backendlessId {
            BackendlessAppventure.removeBy(id: backendlessId)
        }
        AppDelegate.coreDataStack.delete(object: appventure, completion: nil)

    }
    
}


//MARK: - Fetched Results Delegate

extension MakerHomeViewController: NSFetchedResultsControllerDelegate {
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
        
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
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

//MARK: - AnimatedSegmentControlDelegate
extension MakerHomeViewController: AnimatedSegmentControlDelegate {
    
    func updatedButton(index: Int) {
        fethcedAppventuresController.fetchRequest.predicate = index == 0 ? NSPredicate(format: "owner == %@", CoreUser.user!) : NSPredicate(format: "contributer == %@", CoreUser.user!)
        do {
            try fethcedAppventuresController.performFetch()
        } catch {
            print("An error occurred")
        }
        tableView.reloadData()
    }
}
