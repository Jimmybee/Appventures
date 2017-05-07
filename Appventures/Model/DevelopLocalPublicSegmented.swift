//
//  DevelopLocalPublicSegmented.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation



class DevelopLocalPublicSegmented: UISegmentedControl {

    
    override init(items: [Any]?) {
        super.init(items: items)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        self.subviews[2].tintColor = Colours.myRed
        self.subviews[1].tintColor = Colours.myBlue
        self.subviews[0].tintColor = Colours.myYellow
    }
    
    
    func setToLive() {
        self.subviews[0].tintColor = Colours.myRed
        self.subviews[2].tintColor = Colours.myBlue
        self.subviews[1].tintColor = Colours.myGreen
        self.setTitle("Live", forSegmentAt: 2)
    }
}
