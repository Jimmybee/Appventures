//
//  TimePicker.swift
//  EA - Clues
//
//  Created by James Birtwell on 22/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

protocol TimePickerDelegate: class {
    func dismissPressed()
    func donePressed()
}

class TimePicker: UIView {
    
    weak var delegate: TimePickerDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
     
    }
    
    @IBAction func dimiss(_ sender: Any) {
        delegate.dismissPressed()
    }
    
    @IBAction func done(_ sender: Any) {
        delegate.donePressed()
    }
}
