//
//  SegmentButton.swift
//  Appventures
//
//  Created by James Birtwell on 10/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class SegmentButton: UIButton {
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue == true {
//                self.titleLabel?.textColor = Colors.pink
            } else {
//                self.titleLabel?.textColor = .darkGray
            }
        }
    }
    
    
}
