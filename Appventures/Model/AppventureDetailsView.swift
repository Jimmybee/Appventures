//
//  AppventureDetailsView.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import PureLayout

protocol AppventureDetailsViewDelegate: class {
    
    func leftBttnPressed()
    func rightBttnPressed(sender: UIButton)

}

class AppventureDetailsView: UIView, UIScrollViewDelegate{
    
    var appventure: Appventure!
    weak var delegate: AppventureDetailsViewDelegate!
    
    @IBOutlet weak var appventureImage: UIImageView!
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var seeMapBttn: UIButton!
    @IBOutlet weak var shareOrSave: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var greyBox: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var numberOfStepsLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        setupModel()
        setView()
    }
    
    func setView() {
        greyBox.layer.cornerRadius = 4
        greyBox.layer.borderWidth = 0.5
        greyBox.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func leftBttnPressed(_ sender: UIButton) {
        delegate.leftBttnPressed()
    }
    
    @IBAction func rightBttnPressed(_ sender: UIButton) {
        delegate.rightBttnPressed(sender: sender)
    }
    
    func setupModel() {
        if let image = appventure.image { appventureImage.image = image }
        appventureTitle.text = appventure.title
        descriptionLabel.text = appventure.subtitle
        durationLabel.text = appventure.duration.secondsComponentToLongTimeString()
        startingLocation.text = appventure.startingLocationName
        numberOfStepsLabel.text = "\(appventure.appventureSteps.count) clues"
    }
}
