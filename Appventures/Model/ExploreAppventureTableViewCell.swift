//
//  LocalAppventureTableViewCell.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import Alamofire

class ExploreAppventureTableViewCell: UITableViewCell, AppventureImageCell {
    
    var appventure: Appventure? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var appventureImage: UIImageView! //dont block main thread
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var ratingDisplay: RatingControlOrangeDisplay!
    
    //    @IBOutlet weak var ratingDisplay: RatingControl!
    
    override func awakeFromNib() {
        appventureImage.image = nil
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI() {
        startingLocation.text = appventure?.startingLocationName
        duration.text = appventure?.duration.secondsComponentToLongTimeString()
        appventureTitle.text = appventure?.title
        ratingDisplay.rating = (appventure?.rating)!
        if let image = appventure?.image {
            appventureImage.image = image
        } else {
            appventureImage.alpha = 0
            appventure?.loadImageFor(cell: self)
        }
    }
    
    
}
