//
//  LiveStatus.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


enum LiveStatus: Int16 {
    case live = 0
    case waitingForApproval = 1
    case inDevelopment = 2
    case local = 3
    
    var label: String {
        switch self {
        case .live: return "Live"
        case .waitingForApproval: return "Awaiting Approval"
        case .inDevelopment: return "In Develoopment"
        case .local: return "Local"
        }
    }
    
    func segmentValue() -> Int {
        switch self {
        case .inDevelopment: return 0
        case .local: return 1
        case .waitingForApproval: return 2
        case .live: return 3
        }
    }
}

