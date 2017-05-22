//
//  TableHeaderSection.swift
//  EpicAppventures
//
//  Created by James Birtwell on 02/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

protocol TableSectionHeaderDelegate: class {
    func sectionHeaderBttnTapped(tag: Int)
}


//MARK: Table

class TableSectionHeader: UITableViewCell {
    
    static var cellIdentifierNibName = "TableHeaderSection"
    
    
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    
    weak var delegate: TableSectionHeaderDelegate!
    
    
    @IBAction func sectionButton(_ sender: UIButton) {
        delegate.sectionHeaderBttnTapped(tag: sectionButton.tag)
    }
    
}
