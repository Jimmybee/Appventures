//
//  LocalAppventureTableViewCell.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit

class ExploreAppventureCell: UITableViewCell, AppventureImageCell {
    
    static let cellIdentifierNibName = "ExploreAppventureCell"
    
    var appventure: Appventure? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var appventureImage: UIImageView! //dont block main thread
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var themeOne: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        appventureImage.image = nil
        super.awakeFromNib()
    }
    
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        appventureImage.image = nil
    }
    
    func updateUI() {
        startingLocation.text = appventure?.startingLocationName
        appventureTitle.text = appventure?.title
        themeOne.text = appventure?.themeOne ?? "Theme"

        if let image = appventure?.image {
            appventureImage.image = image
        } else {
            print("do load...")
//            appventureImage.alpha = 0
            appventure?.loadImageFor(cell: self)
        }
    }
    
    
}
