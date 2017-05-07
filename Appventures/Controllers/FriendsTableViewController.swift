//
//  FriendsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FriendsTableViewController: BaseTableViewController {
    
    var appventure: Appventure?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriends()   
    }
    
    func loadFriends() {
        showProgressView()
        CoreUser.user?.getFriends(completion: {
            self.hideProgressView()
            self.tableView.reloadData()
        })
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FacebookFriendTableCell
        cell.facebookFriend = CoreUser.user?.facebookFriends[indexPath.row]
        cell.setupViewContent()
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if CoreUser.user?.facebookFriends.count > 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.backgroundView = UIView()
            return 1
        } else {
            let message = "No friends are using this app"
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (CoreUser.user?.facebookFriends.count)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let friendID = CoreUser.user!.facebookFriends[row].id
        
        let alert = UIAlertController(title: "Share", message: "Share with friend?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            let share = SharedAdventure(shareeFbId: friendID, appventureId: self.appventure!.backendlessId!)
            share.save(completion: {print("handler in share ")})
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
 


}

extension FriendsTableViewController {
    
    func shareComplete(_ succes: Bool) {
        var message : String = ""
        succes ?  (message = "Adventure shared!") :  (message = "Adventure not shared!")
        let alert = UIAlertController(title: "Share", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        

        
        self.present(alert, animated: true, completion: nil)
    }
    
}
