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
    
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}


