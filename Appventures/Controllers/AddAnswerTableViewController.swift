//
//  AddAnswerTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import CoreData

class AddAnswerTableViewController: UITableViewController {
    
    var step: AppventureStep!
    var fetchedAnswersController: NSFetchedResultsController<StepAnswer>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createController()
    }
    
    func createController() {
        let context = step.managedObjectContext
        let primarySortDescriptor = NSSortDescriptor(key: "answer", ascending: true)
        let fetch:NSFetchRequest<StepAnswer> = StepAnswer.fetchRequest()

        fetch.sortDescriptors = [primarySortDescriptor]
        fetch.predicate = NSPredicate(format: "step == %@", step)

        fetchedAnswersController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedAnswersController.delegate = self
        do {
            try fetchedAnswersController.performFetch()
        } catch {
            print("An error occurred")
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedAnswersController.sections {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = UIView()
            return sections.count
        } else {
            let message = "No answers added yet."
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        
        return 0

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedAnswersController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }

    @IBAction func addAnswer(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Answer", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            let newAnswer = alert.textFields![0].text
            self.addAnswerToTable(newAnswer)
        }))
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Answer"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addAnswerToTable(_ textfieldString: String?) {
        if let answer = textfieldString {
            _ = StepAnswer(step: step, answer: answer, correct: true, context: step.managedObjectContext!)
        }
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let answer = fetchedAnswersController.object(at: indexPath)

        cell.textLabel?.text = answer.answer

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Answer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            let newAnswer = alert.textFields![0].text
            self.fetchedAnswersController.object(at: indexPath).answer = newAnswer
        }))
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.text = self.fetchedAnswersController.object(at: indexPath).answer
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let answer = fetchedAnswersController.object(at: indexPath)
        AppDelegate.coreDataStack.delete(object: answer, completion: nil)
    }


}


extension AddAnswerTableViewController: NSFetchedResultsControllerDelegate {
    
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
                let answer = self.fetchedAnswersController.object(at: updateIndexPath)
                
                cell?.textLabel?.text = answer.answer
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



