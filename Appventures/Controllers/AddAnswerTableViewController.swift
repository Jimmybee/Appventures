//
//  AddAnswerTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class AddAnswerTableViewController: UITableViewController {
    
    var step: AppventureStep!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.step.answerText.count > 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.backgroundView = UIView()
            return 1
        } else {
                let message = "No answers added yet."
                HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        return 0

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return step.answerText.count
    }

    @IBAction func addAnswer(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Answer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
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
            self.step.answerText.append(answer)
            tableView.reloadData()
        }
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = step.answerText[indexPath.row]

        return cell
    }
    
    func updateAnswerInTable(_ textFieldString: String?, index: Int) {
        if let answer = textFieldString {
            self.step.answerText[index] = answer
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Answer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            let newAnswer = alert.textFields![0].text
            self.updateAnswerInTable(newAnswer, index: indexPath.row)
        }))
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.text = self.step.answerText[indexPath.row]
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.step.answerText.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }


}
