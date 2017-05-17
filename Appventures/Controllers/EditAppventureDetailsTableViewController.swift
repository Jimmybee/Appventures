//
//  EditAppventureDetailsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 03/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import PureLayout
import GooglePlacePicker

protocol EditAppventureDetailsTableViewControllerDelegate: class {
    func appventureRolledBack()
}

class EditAppventureDetailsTableViewController: UITableViewController {
    
    var appventure: Appventure?
    weak var delegate: EditAppventureDetailsTableViewControllerDelegate!
    var placePicker: GMSPlacePicker!

    //MARK: Outlets
    //TextView
    @IBOutlet weak var appventureDescription: UITextView!
    //TextField
    @IBOutlet weak var appventureNameField: UITextField!
    @IBOutlet weak var startingLocation: UITextField!
    //Views
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveBtt: UIBarButtonItem!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationPicker: UIDatePicker!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var restrictionsPicker: UIDatePicker!
    
    @IBOutlet weak var tags: UILabel!
    
    let imageViewIndex = IndexPath(row: 0, section: 1)
    let pickLocationCell = IndexPath(row:1, section: 4)
    let descriptionTextIndex = IndexPath(row:0, section: 3)
    let duationLabelIndex = IndexPath(row: 0, section: 5)
    let durationPickerIndex = IndexPath(row: 1, section: 5)
    let startTimeIndex = IndexPath(row:0, section: 6)
    let endTimeIndex = IndexPath(row: 1, section: 6)
    let restrictionTimePickerIndex = IndexPath(row: 2, section: 6)

    var placeCache: PlaceCache?
    
    //MARK: Flags
    var edittingDuration = false
    var edittingStartTime = false
    var edittingEndTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if appventure != nil { updateUI() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if appventure != nil {
            updateSafeOnViewDidAppear()
        }
    }
    
    func setupViews() {
        restrictionsPicker.isHidden = true
        restrictionsPicker.alpha = 0
        restrictionsPicker.setDate(Date(), animated: false)
        restrictionsPicker.locale = Locale(identifier: "en_GB")
        durationPicker.isHidden = true
        durationPicker.alpha = 0
        durationPicker.setDate(Date(), animated: false)
    }
    
    func setupForNewAppventure() {
        tags.text = "Select..."
    }
    
    func updateUI(){
        appventureNameField.text =  appventure!.title
        appventureDescription.text = appventure!.subtitle
        durationLabel.text = appventure!.duration.secondsComponentToLongTimeString()
        startingLocation.text = appventure!.startingLocationName
        startTimeLabel.text = appventure?.startTime
        endTimeLabel.text = appventure?.endTime
        updateSafeOnViewDidAppear()
    }
    
    func updateSafeOnViewDidAppear() {
        let themeTwo = appventure?.themeTwo == nil ? "" : ", \(appventure!.themeTwo!)"
        let themeOne = appventure!.themeOne ?? ""
        tags.text = themeOne + themeTwo
        if appventure?.image != nil {
            imageView.image = appventure!.image
        }
    }
    
    func checkSave() {
        self.saveBtt.isEnabled = true
    }

    
    //MARK: IBActions 
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        AppDelegate.coreDataStack.rollbackContext()
        self.dismiss(animated: true, completion: nil)
        delegate.appventureRolledBack()
    }
    
    @IBAction func save(_ sender: AnyObject) {
        updateAppventure()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAppventure() {
        appventure!.title = appventureNameField.text
        appventure!.subtitle = appventureDescription.text
        appventure!.startingLocationName = startingLocation.text
        appventure!.image = imageView.image
        AppDelegate.coreDataStack.saveContext(completion: nil)
    }
    
    @IBAction func durationPickerChanged(_ sender: UIDatePicker) {
        appventure?.duration = sender.date.asTimeSecondsComponent()
        durationLabel.text = appventure!.duration.secondsComponentToLongTimeString()
    }
    
    @IBAction func restrictionsPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if edittingStartTime { appventure?.startTime =  dateFormatter.string(from: sender.date)}
        if edittingEndTime { appventure?.endTime = dateFormatter.string(from: sender.date)}
        startTimeLabel.text = appventure?.startTime
        endTimeLabel.text = appventure?.endTime
    }
    
}

//MARK: - Navigation 

extension EditAppventureDetailsTableViewController  {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tsvc = segue.destination as? ThemeSelectorViewController else { return }
        tsvc.appventure = self.appventure
    }
}

//MARK: UIImagePickerControllerDelegate
extension EditAppventureDetailsTableViewController : ImagePicker {
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            let savedImage = HelperFunctions.resizeImage(pickedImage, desiredWidth: 800)
            appventure?.image = savedImage
            appventure?.requiresImageSave = true
        }
        
        checkSave()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UITextViewDelegate
extension EditAppventureDetailsTableViewController : UITextViewDelegate {
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView == appventureDescription {
                checkSave()
            }
        }
    
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}

//MARK: UITextFieldDelegate
extension EditAppventureDetailsTableViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSave()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: Table Functions
extension EditAppventureDetailsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch indexPath {
        case duationLabelIndex:
            edittingDuration = !edittingDuration
            edittingEndTime = false
            edittingStartTime = false
        case pickLocationCell:
             pickLocation() 
        case startTimeIndex:
            edittingStartTime = !edittingStartTime
            edittingEndTime = false
            edittingDuration = false
        case endTimeIndex:
            edittingEndTime = !edittingEndTime
            edittingStartTime = false
            edittingDuration = false
        default:
            break
        }

        animation()

        tableView.beginUpdates()
        tableView.endUpdates()
        
        if self.edittingStartTime || self.edittingEndTime {
            self.tableView.scrollToRow(at: self.restrictionTimePickerIndex, at: .bottom, animated: true)
        }
        
        if edittingDuration {
            tableView.scrollToRow(at: durationPickerIndex, at: .bottom, animated: true)
        }
        
        if indexPath.section == 1 {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Take Image", style: UIAlertActionStyle.default, handler: { action in
                HelperFunctions.getImage(true, delegate: self, presenter: self)
                
            }))
            alert.addAction(UIAlertAction(title: "Pick From Library", style: UIAlertActionStyle.default, handler: { action in
                HelperFunctions.getImage(false, delegate: self, presenter: self)
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.navigationController?.view.layoutIfNeeded()
            })
            
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44
        
        switch indexPath {
        case imageViewIndex:
            height = 218
        case descriptionTextIndex:
            height = 180
        case durationPickerIndex:
            height = edittingDuration ? 218 : 0
        case restrictionTimePickerIndex:
            if edittingStartTime || edittingEndTime { height = 218 } else { height = 0}
        default:
            height = UITableViewAutomaticDimension
        }
        
        return height
    }
    
    func animation() {
        restrictionsPicker.isHidden = edittingStartTime || edittingEndTime ? false : true
        durationPicker.isHidden = edittingDuration ?  false : true
        UIView.animate(withDuration: 1.2, animations: {
            self.durationPicker.alpha = self.edittingDuration ? 1 : 0
            self.restrictionsPicker.alpha = self.edittingStartTime || self.edittingEndTime ? 1 : 0
        }) { (complete) in
        
        }
        
        durationPicker.date = appventure!.duration.secondsComponentToDate()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if edittingStartTime { restrictionsPicker.date = dateFormatter.date(from: appventure!.startTime!)! }
        if edittingEndTime { restrictionsPicker.date = dateFormatter.date(from: appventure!.endTime!)! }

        durationLabel.textColor = edittingDuration ? UIColor.blue : UIColor.black
        startTimeLabel.textColor = edittingStartTime ? UIColor.blue : UIColor.black
        endTimeLabel.textColor = edittingEndTime ? UIColor.blue : UIColor.black

    }
    
    //MARK: GMS Picker
    func pickLocation() {
        var center: CLLocationCoordinate2D?
        
        if let currentCoordinate = appventure?.location.coordinate as CLLocationCoordinate2D! {
            if CLLocationCoordinate2DIsValid(currentCoordinate) {
                center = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude)
            }
            center = CLLocationCoordinate2DMake(0, 0)
        } else {
            center = CLLocationCoordinate2DMake(0, 0)
        }
        
        let northEast = CLLocationCoordinate2DMake(center!.latitude + 0.001, center!.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center!.latitude - 0.001, center!.longitude - 0.001)
        
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.placeCache = PlaceCache(place: place)
                self.appventure?.location = self.placeCache!.coordinate
            } else {
                print("No place selected")
            }
        })
    }
    
    
}





