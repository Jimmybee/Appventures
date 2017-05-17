//
//  CompletedAppventureTableViewCell.swift
//  Appventures
//
//  Created by James Birtwell on 16/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

class CompletedAppventureTableViewCell: UITableViewCell {
    
    static var cellIdentifierNibName = "CompletedAppventureTableViewCell"

    var appventure: CompletedAppventure!
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamTime: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell() {
        teamName.text = appventure.teamName
        teamTime.text = HelperFunctions.formatTime(appventure.time, nano: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
