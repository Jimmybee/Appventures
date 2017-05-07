//
//  ImageChooserViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ImageChooserViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var step: AppventureStep!
    
    @IBOutlet weak var selectImageLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if step.image != nil {
            selectImageLabel.alpha = 0
            imageView.image = step.image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IB Actions
    
    @IBAction func changeImageTap(_ sender: AnyObject) {
        print("tapped")
        self.changeImage()
        
    }
    @IBAction func changeImage() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.default, handler: { action in
            self.getImage(true)
        }))
        alert.addAction(UIAlertAction(title: "Choose From Library", style: UIAlertActionStyle.default, handler: { action in
            self.getImage(false)

        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: ImagePicker
    
    func getImage(_ useCamera: Bool) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if useCamera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            let savedImage = HelperFunctions.resizeImage(pickedImage, newWidth: 300)
            imageView.image = savedImage
            step.image = savedImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
