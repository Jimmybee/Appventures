//
//  FilterCollectionCell.swift
//  Appventures
//
//  Created by James Birtwell on 12/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {
    
    static var nibName = "FilterCollectionCell"
    
    var filter: String!
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                self.filterImage.alpha = 1
            } else {
                self.filterImage.alpha = 0.6
            }
        }
    }
    
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}


