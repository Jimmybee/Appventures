//
//  ImageNames.swift
//  EA - Clues
//
//  Created by James Birtwell on 29/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

struct ImageNames {
    struct VcStep {
        static let map = "vc_step_map"
        static let mapSelected = "vc_step_map_selected"
        static let file = "vc_step_file"
        static let fileSelected = "vc_step_file_selected"
        static let camera = "vc_step_camera"
        static let cameraSelected = "vc_step_camera_selected"
        static let sound = ""
        static let soundSelected = "vc_step_sound_selected"
        static let checkIn = "vc_step_checkIn"
        static let submit = "vc_step_submit"
    }
    
    struct VcCreate {
        static let checkIn = UIImage(named:"vc_create_check_in")
        static let compassStrike = UIImage(named:"vc_create_compass_strike")
        static let compass = UIImage(named:"vc_create_compass")
        static let locationOnMapStrike = UIImage(named:"vc_create_location_on_map_strike")
        static let locationOnMap = UIImage(named:"vc_create_location_on_map")
        static let multipleChoice = UIImage(named:"vc_create_multiple_choice")
        static let pencilHighlight = UIImage(named:"vc_create_pencil_highlight")
        static let rulerStrike = UIImage(named:"vc_create_ruler_strike")
        static let ruler = UIImage(named:"vc_create_ruler")
        static let flag = UIImage(named:"vc_create_flag")
    }
    
    struct Common {
        static let location = UIImage(named:"common_location")
        static let locationStrike = UIImage(named:"common_location_strike")

    }
}
