//
//  TargetHelperFunctions.swift
//  EpicAppventures
//
//  Created by James Birtwell on 22/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class TargetHelperFunctions {
    //MARK: Image Functions
    
    struct Constants {
        static let ImageFullscreenVC = "ImageFullscreenVC"
    }

    
    class func openLargeImage (_ image: UIImage, vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Interactive", bundle:nil)
        if let ifvc = storyBoard.instantiateViewController(withIdentifier: Constants.ImageFullscreenVC) as? ImageFullscreenViewController {
            ifvc.image = image
            vc.present(ifvc, animated: true, completion: nil)
        }
    }
    
    class func getImage(_ useCamera: Bool, delegate: UIViewController) {
        
        let imagePicker = UIImagePickerController()
        
//        if let  iavc = delegate as? ImageAssetViewController {
//            imagePicker.delegate = iavc
//        }
        
        
        if useCamera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        
        delegate.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
}
