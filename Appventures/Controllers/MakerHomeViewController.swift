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
    
    struct Constants {
        static let CellName = "Cell"
        static let segueCreateNewAppventure = "Create New Appventure"
        static let segueEditAppventure = "Edit Appventure"
        static let segueSettings = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CoreUser.checkLogin(false, vc: self) {
            if CoreUser.user!.ownedAppventures?.count == 0 {
                restoreAppventures()
            }
        }
        tableView.refreshControl?.tintColor = .white
        getSharedAppventures()
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
        SharedAdventure.getGrantedSharedAppventures(shareeFbId: CoreUser.user!.facebookId!) { appventures in
            
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
                    if let row = tableView.indexPath(for: tbCell)!.row as Int! {
                        cavc.newAppventure = Array(CoreUser.user!.ownedAppventures!)[row]
                        cavc.appventureIndexRow = row
                    }
                }
            }
            cavc.delegate = self
        }
    }

    //MARK: Table functions
    
    var tableMessage = ""
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if CoreUser.user != nil {
            if CoreUser.user!.ownedAppventures!.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = tableMessage
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreUser.user!.ownedAppventures!.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellName) as! AppventureMakerCell
        
        let row = indexPath.row
        let appventureArray = Array(CoreUser.user!.ownedAppventures!)
        cell.appventure = appventureArray[row]
        
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
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Appventure?", message: "Appventure data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteAppventureFromDB(indexPath)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAppventureFromDB (_ indexPath: IndexPath) {
        let appventureArray = Array(CoreUser.user!.ownedAppventures!)
        let appventure = appventureArray[indexPath.row]
        guard  let backendlessId = appventure.backendlessId else { return }
        BackendlessAppventure.removeBy(id: backendlessId)
        AppDelegate.coreDataStack.delete(object: appventure, completion: nil)
        tableView.reloadData()
    }
    
}


extension MakerHomeViewController : CreateAppventureViewControllerDelegate {
    
    func reloadTable() {
        tableView.reloadData()
    }
}

