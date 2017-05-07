//
//  AppventureMakerCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//


import UIKit
//import Parse

class AppventureMakerCell: UITableViewCell, AppventureImageCell {
    
    var appventure: Appventure? { didSet { updateUI()  }}
    
    @IBOutlet weak var appventureImage: UIImageView! //dont block main thread
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    
    //    @IBOutlet weak var ratingDisplay: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func loadImage(_ image :UIImage) {
        DispatchQueue.main.async { () -> Void in
            self.appventureImage.image = image
            self.appventure?.image = image
        }
    }
    
    func updateUI() {
        self.locationLabel.text = appventure?.startingLocationName
        self.appventureTitle.text = appventure?.title
        
        if appventure?.image != nil {
            self.appventureImage.image = appventure?.image
        } else {
            appventureImage.image = nil
            appventure?.loadImageFor(cell: self)
            
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { () -> Void in

        }
    }

    
    
}

protocol AppventureImageCell {
    var appventureImage: UIImageView! {get set}
    
    func setNeedsDisplay()
}

