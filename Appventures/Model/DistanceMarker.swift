//
//  DistanceMarker.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/10/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

class DistanceMarker: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init()
    {
        self.init()
    }

    
    @IBOutlet weak var distanceText: UILabel!
    
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
}
