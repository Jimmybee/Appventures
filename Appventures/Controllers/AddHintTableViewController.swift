//
//  AddhintTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import CoreData

class AddHintTableViewController: UITableViewController {
    
    var step: AppventureStep!
    var fetchedhintsController: NSFetchedResultsController<StepHint>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createController()
    }
    
    func createController() {
        let context = step.managedObjectContext
        let primarySortDescriptor = NSSortDescriptor(key: "hint", ascending: true)
        let fetch:NSFetchRequest<StepHint> = StepHint.fetchRequest()
        
        fetch.sortDescriptors = [primarySortDescriptor]
        fetch.predicate = NSPredicate(format: "step == %@", step)
        
        fetchedhintsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedhintsController.delegate = self
        do {
            try fetchedhintsController.performFetch()
        } catch {
            print("An error occurred")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedhintsController.sections {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = UIView()
            return sections.count
        } else {
            let message = "No hints added yet."
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedhintsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    @IBAction func addHint(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New hint", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            let newhint = alert.textFields![0].text
            self.addhintToTable(newhint)
        }))
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Hint"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addhintToTable(_ textfieldString: String?) {
        if let hint = textfieldString {
            _ = StepHint(step: step, hint: hint, context: step.managedObjectContext!)
        }
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let hint = fetchedhintsController.object(at: indexPath)
        
        cell.textLabel?.text = hint.hint
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Hint", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            let newhint = alert.textFields![0].text
            self.fetchedhintsController.object(at: indexPath).hint = newhint
        }))
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.text = self.fetchedhintsController.object(at: indexPath).hint
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let hint = fetchedhintsController.object(at: indexPath)
        AppDelegate.coreDataStack.delete(object: hint, completion: nil)
    }
    
    
}


extension AddHintTableViewController: NSFetchedResultsControllerDelegate {
    
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
                let cell = self.tableView.cellForRow(at: updateIndexPath)
                let hint = self.fetchedhintsController.object(at: updateIndexPath)
                
                cell?.textLabel?.text = hint.hint
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



