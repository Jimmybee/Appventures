//
//  AppventureTableViewCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 01/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class AppventureStepTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var StepID: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var answer: UILabel!


}

