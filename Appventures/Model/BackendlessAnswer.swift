//
//  BackendlessSetup.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessAnswer: NSObject {
    
    public var answer: String!
    public var objectId: String!
    public var correct: Bool = true

    override init() {
       super.init()
    }
    
    init(stepAnswer: StepAnswer) {
        self.objectId = stepAnswer.backendlessId
        self.answer = stepAnswer.answer
        self.correct = stepAnswer.correct
    }
    
}
