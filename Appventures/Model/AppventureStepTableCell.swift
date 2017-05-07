//
//  AppventureStepTableCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import PureLayout

class AppventureStepTableCell: UITableViewCell {
    
    var step: AppventureStep!
    
    var clueTypes = [UIImageView]()
    
    @IBOutlet weak var locationPinImage: UIImageView!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var stepNameOrLocation: UILabel!
    @IBOutlet weak var secondRowView: UIView!
    @IBOutlet weak var answerTypeImage: UIImageView!
    @IBOutlet weak var locationImage1: UIImageView!
    @IBOutlet weak var locationImage2: UIImageView!
    @IBOutlet weak var locationImage3: UIImageView!
    @IBOutlet weak var hintsCount: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupView() {
        clueTypes.removeAll()
        let file = UIImage(named: ImageNames.VcStep.fileSelected)
        let camera = UIImage(named: ImageNames.VcStep.cameraSelected)
        let sound = UIImage(named: ImageNames.VcStep.soundSelected)

        if step.setup.textClue == true {clueTypes.append(UIImageView(image: file))}
        if step.setup.pictureClue == true {clueTypes.append(UIImageView(image: camera))}
        if step.setup.soundClue == true {clueTypes.append(UIImageView(image: sound))}
        
        locationImage1.image = step.setup.locationShown ? ImageNames.VcCreate.locationOnMap : ImageNames.VcCreate.locationOnMapStrike
        locationImage2.image = step.setup.compassShown ? ImageNames.VcCreate.compass : ImageNames.VcCreate.compassStrike
        locationImage3.image = step.setup.distanceShown ? ImageNames.VcCreate.ruler : ImageNames.VcCreate.rulerStrike
        locationPinImage.image = step.setup.isLocation ? ImageNames.Common.location : ImageNames.Common.locationStrike
        answerTypeImage.image = step.setup.checkIn ? ImageNames.VcCreate.checkIn : ImageNames.VcCreate.pencilHighlight
        
        stepNumberLabel.text = String(step.stepNumber)
        stepNameOrLocation.text = step.nameOrLocation
        hintsCount.text = String(step.freeHints)
        
        let locationImages = [locationImage1, locationImage2, locationImage3]
        
        for (index, clueImage) in clueTypes.enumerated() {
            secondRowView.addSubview(clueImage)
            clueImage.autoSetDimension(.height, toSize: 23)
            switch clueImage.image! {
            case camera!:
                clueImage.autoSetDimension(.width, toSize: 32)
            default:
                clueImage.autoSetDimension(.width, toSize: 18)
            }
            clueImage.autoAlignAxis(.vertical, toSameAxisOf: locationImages[index]!)
            clueImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        }

    }
    
}
