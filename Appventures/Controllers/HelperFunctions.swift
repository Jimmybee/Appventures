//
//  HelperFunctions.swift
//  EpicAppventures
//
//  Created by James Birtwell on 06/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}


import Foundation
//import Parse



protocol ImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
}

class HelperFunctions {
    
    class func openMaps( _ query: String, vc: UIViewController, mapType: String = "Google") {
        var query = query
        
//        let address = "American Tourister, Abids Road, Bogulkunta, Hyderabad, Andhra Pradesh, India"
//        let escapedAddress = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//        let urlpath = NSString(format: "http://maps.googleapis.com/maps/api/geocode/json?address=\(escapedAddress)")
//        print(urlpath)
        query = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        if let targetURLGoogle = URL(string:"comgooglemaps://?q=\(query)") {
            if UIApplication.shared.canOpenURL(targetURLGoogle) {
                UIApplication.shared.open(targetURLGoogle, options: [:], completionHandler: nil)
            } else if let targetURLApple = URL(string: "http://maps.apple.com/?q=\(query)")  {
            if UIApplication.shared.canOpenURL(targetURLApple) {
                UIApplication.shared.open(targetURLApple, options: [:], completionHandler: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Open Maps", message: "No directions available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            vc.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    class func formatTime(_ ms: Double, nano: Bool) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits.insert(NSCalendar.Unit.hour)
        formatter.allowedUnits.insert(NSCalendar.Unit.minute)
        formatter.allowedUnits.insert(NSCalendar.Unit.second)
        if nano == true {
        formatter.allowedUnits.insert(NSCalendar.Unit.nanosecond)
        }
        formatter.zeroFormattingBehavior.insert(DateComponentsFormatter.ZeroFormattingBehavior.pad)
        return formatter.string(from: ms)
    }

    class func formatDistance(_ distance: Double) -> String {
        if distance > 9500 {
            let formattedDistance = "\(Int(distance)/1000) Km"
            return formattedDistance
        } else {
            let formattedDistance = "\(Int(distance)) m"
            return formattedDistance
            
        }
        
    }
    
    class func convertImage (_ image: UIImage) -> AnyObject? {
        _ = UIImagePNGRepresentation(image) as Data!
//        let imageFile = PFFile(name:"image.png", data:imageData)
//        return imageFile!
        return nil
    }
    
    class func loadAppventureSetup(_ object: AnyObject) -> Appventure {
//        let appventureName = object.objectForKey(Appventure.pfAppventure.pfTitle) as! String
//        let appventureLocate = object.objectForKey(Appventure.pfAppventure.pfCoordinate) as! PFGeoPoint
//        let appventurePFID = object.objectId!
//        let appventure = Appventure(PFObjectID: appventurePFID, name: appventureName, geoPoint: appventureLocate)
//        appventure.subtitle = object.objectForKey(Appventure.pfAppventure.pfSubtitle) as? String
//        appventure.pfFile = object[Appventure.pfAppventure.pfAppventureImage] as? PFFile
//        appventure.totalDistance = object[Appventure.pfAppventure.pfTotalDistance] as! Double
//        return appventure
        return Appventure()
    }
    
//    MARK: ImageFunctions
    class func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let oldData = UIImageJPEGRepresentation(image, 1)
        print(oldData?.count as Any)
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(newImage!, 0.8)
        print(imageData?.count ?? "")
        let finalImage = UIImage(data: imageData!)
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    class func getImage(_ useCamera: Bool, delegate: ImagePicker, presenter: UIViewController) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        
        if useCamera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        presenter.present(imagePicker, animated: true, completion: nil)
        
    }
    
    class func circle(_ image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.black.cgColor
    }
    
    class func blurImage(_ image:UIImage, radius: Double, forRect rect: CGRect) -> UIImage?
    {
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: image.cgImage!)
        
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue((radius), forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage:CGImage?
        
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: rect)
        }
        
        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA)
        }
        
        return nil
    }

    
    //MARK: tableFunctions
    
    class func noTableDataMessage (_ tableView: UITableView, message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height ))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.font = UIFont(name: "Palatino", size: 20)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //MARK: Tab functions
    
    class func unhideTabBar(_ vc: UIViewController){
        if let mtvc = vc.tabBarController as? MainTabBarController {
            if mtvc.stdFrame != nil {
                if mtvc.tabBar.frame != mtvc.stdFrame {
                    mtvc.tabBar.isHidden = false

                    UIView.animate(withDuration: 0.3, animations: {
                        mtvc.tabBar.frame = mtvc.stdFrame!.offsetBy(dx: 0, dy: 0)

                        }, completion: { (complete) in
                    })

                }
            }
        }
    }
    
    class func hideTabBar(_ vc: UIViewController){
        if let mtvc = vc.tabBarController as? MainTabBarController {
            if mtvc.stdFrame != nil {
                if mtvc.tabBar.frame == mtvc.stdFrame {
                    let height = mtvc.stdFrame?.size.height
                    UIView.animate(withDuration: 0.3, animations: {
                        mtvc.tabBar.frame = mtvc.stdFrame!.offsetBy(dx: 0, dy: height!)
                        mtvc.tabBar.isHidden = true

                        }, completion: { (complete) in
                            
                    })
                }
            }
        }
    }

    
}

extension String {
    func splitStringToArray() -> [String] {
        return self.characters.split{$0 == ","}.map(String.init)
    }
}


//MARK: View extensions
//ImageRotation.swift
import UIKit

extension UIImage {
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {

        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        bitmap?.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

//UIImage from view

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}

//ScrollHolderClass


class clickParentScroll : UIView {
    
    var myScroll = UIScrollView()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.point(inside: point, with: event) ? myScroll : nil
    }
    
}

extension Int64 {
    func secondsComponentToDate() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(second: Int(self)))!
    }
    
    func secondsComponentToLongTimeString() -> String {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(second: Int(self)))!
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let plural = hours == 1 ? "" : "s"
        return ("\(hours) hour\(plural) \(minutes) minutes")
    }
}

extension Date {
    func asTimeSecondsComponent() -> Int64 {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = hours * 60 * 60 + minutes * 60
        return Int64(seconds)
    }
}
