//
//  TimePenaltyViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 22/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class TimePenaltyViewController: UITableViewController {
    
    var step: AppventureStep!
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCheckmark()

    }
}

extension TimePenaltyViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath == selectedIndexPath {
            return
        }
        
        setCheckMarkFor(indexPath: indexPath)
        if let cell = tableView.cellForRow(at: selectedIndexPath) {
            cell.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
        step.hintPenalty = Int16(penaltyTimeFor(indexPath: indexPath))
        
    }
    
    func penaltyTimeFor(indexPath: IndexPath) -> Int {
        switch indexPath.section {
        case 0:
            return 0
        default:
            switch indexPath.row {
            case 0:
                return 30
            case 1:
                return 60
            case 2:
                return 120
            case 3:
                return 300
            case 4:
                return 600
            default:
                return 0
            }
            
        }
    }
    
    func setupCheckmark() {
        switch step.hintPenalty {
        case 0:
            selectedIndexPath = IndexPath(row: 0, section: 0)
        case 30:
            selectedIndexPath = IndexPath(row: 0, section: 1)
        case 60:
            selectedIndexPath = IndexPath(row: 1, section: 1)
        case 120:
            selectedIndexPath = IndexPath(row: 2, section: 1)
        case 300:
            selectedIndexPath = IndexPath(row: 3, section: 1)
        case 600:
            selectedIndexPath = IndexPath(row: 4, section: 1)
        default:
            selectedIndexPath = IndexPath(row: 5, section: 1)
        }
        
        setCheckMarkFor(indexPath: selectedIndexPath)

    }
    
    
    func setCheckMarkFor(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
}


