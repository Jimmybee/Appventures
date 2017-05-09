//
//  CardView.swift
//  Appventures
//
//  Created by James Birtwell on 09/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
    }
    
}
