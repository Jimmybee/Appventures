//
//  AddTagsCollectionCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

protocol AddTagsCellDelegate: class {
    func tagBttnTapped(bttn: UIButton)
}

class AddTagsCell: UICollectionViewCell {
    
    weak var delegate: AddTagsCellDelegate!
    
    @IBOutlet weak var tagBttn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func tagBttnTapped(_ sender: UIButton) {
        delegate.tagBttnTapped(bttn: sender)
    }

    
}
