//
//  Filter.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

//*******Class Filter

class Filter: NSObject {
    
    
    enum sortTyping: Int {
        case rating = 0
        case a2Z = 1
        case distance = 2
    }
    
    enum interactivityTypes: Int {
        case all = 0
        case `static` = 1
        case interactive = 2
    }
    
    
    var sortType = sortTyping.rating
    var interactivity = interactivityTypes.all
    var tags = [String]()
    
}
