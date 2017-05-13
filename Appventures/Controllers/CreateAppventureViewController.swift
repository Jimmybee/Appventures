//
//  CreateAppViewController.swift
//  MapPlay
//
//  Created by James Birtwell on 18/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import MapKit
//import Parse
import GoogleMaps

protocol CreateAppventureViewControllerDelegate: NSObjectProtocol {
    func reloadTable()
}

class CreateAppventureViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    struct Constants {
        static let cellName = "StepCell"
        static let placeholderText  = "Add New"
        static let segueNewStep = "Add New Step"
        static let segueAddStepCancel = "Cancel Add Step"
        static let editAppventureDetailsSegue = "Edit Appventure Details"
        static let newTitle = "new"
        static let shareWithFriend = "shareWithFriend"
    }
    
    private(set) lazy var detailsSubView: AppventureDetailsView = {
        let bundle = Bundle(for: AppventureDetailsView.self)
        let nib = bundle.loadNibNamed("AppventureDetailsView", owner: self, options: nil)
        let view = nib?.first as? AppventureDetailsView
        view?.delegate = self
        return view!
    }()
    
    
    var aboveBottom: NSLayoutConstraint!
    var belowBottom: NSLayoutConstraint!
    
//    Model
    var newAppventure: Appventure!
    var delegate: CreateAppventureViewControllerDelegate?
    
    lazy var appventureIndexRow = 999
    
    var userID: String?
    var lastLocation: CLLocation?
    var mapMarkers = [GMSMarker]()
    
    //Process Elements
    var locationManager = CLLocationManager()
    
    //MARK: Outlets
    //Views
    @IBOutlet weak var stepsContainer: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var containerView: UIView!
    //Constraints
    @IBOutlet weak var stepsTopSegmentBottomCon: NSLayoutConstraint!
    @IBOutlet weak var stepsHeight: NSLayoutConstraint!
    
//    @IBOutlet weak var mapBottomSegmentBottom: NSLayoutConstraint!
//    @IBOutlet weak var mapBottomLayoutBottom: NSLayoutConstraint!
    
    @IBOutlet weak var detailsEqualSuperHeight: NSLayoutConstraint! // startsInactive
    @IBOutlet weak var detailsEqualSegmentControlBottom: NSLayoutConstraint! //detailsTop - starts active
    @IBOutlet weak var detailsBottomLayoutBottom: NSLayoutConstraint! //startsActive
    @IBOutlet weak var detailsTopEqualLayoutBottom: NSLayoutConstraint! //startsInactive
    
    func detailsUp () {
        detailsBottomLayoutBottom.isActive = true
        detailsEqualSegmentControlBottom.isActive = true
        detailsTopEqualLayoutBottom.isActive = false
        detailsEqualSuperHeight.isActive = false
    }
    
    func detailsDown() {
        detailsBottomLayoutBottom.isActive = false
        detailsEqualSegmentControlBottom.isActive = false
        detailsTopEqualLayoutBottom.isActive = true
        detailsEqualSuperHeight.isActive = true
    }
    
    //UI Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private(set) lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(CreateAppventureViewController.editDetailsSegue))
        button.tintColor = Colors.purple
        return button
    }()
    private(set) lazy var reorderBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reorder", style: .plain, target: self, action: #selector(CreateAppventureViewController.editStepTable(_:)))
        button.tintColor = Colors.purple
        return button
    }()
    private(set) lazy var doneBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateAppventureViewController.doneEditStepTable(_:)))
        button.tintColor = Colors.purple
        return button
    }()

    
//    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFunctions.hideTabBar(self)
        
        if newAppventure == nil {
            performSegue(withIdentifier: Constants.editAppventureDetailsSegue, sender: nil)
        }
        
        detailsView.addSubview(detailsSubView)
        detailsSubView.autoCenterInSuperview()
        detailsSubView.autoPinEdgesToSuperviewEdges()
        detailsSubView.shareOrSave.setTitle("SAVE", for: .normal)
        self.containerView.bringSubview(toFront: detailsView)

        //Location Manager
        self.locationManager.delegate = self
        getQuickLocationUpdate()
        
        updateUI()
        //Set default edit button action
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        if newAppventure!.appventureSteps.count > 1 {
            if CLLocationCoordinate2DIsValid(newAppventure!.appventureSteps[0].location!.coordinate) {
                newAppventure!.location = newAppventure!.appventureSteps[0].location!
                drawMap()
            }
        }
    }
    
    
    func stepsLoaded(){
        tableView.reloadData()
    }

    @IBAction func shareWithFriends(_ sender: AnyObject) {
//        if CoreUser.user?.facebookConnected == true {
//            performSegue(withIdentifier: Constants.shareWithFriend, sender: nil)
//        } else {
//            let alert = UIAlertController(title: "Share", message: "Log in with facebook to share.", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        
//        self.present(alert, animated: true, completion: nil)
//        }
    }
    
    
    //MARK: UI Interface
    
    func updateUI () {
        tableView.reloadData()
        detailsSubView.appventure = self.newAppventure
        detailsSubView.setup()
    }
    
    //MARK: Private functions
    @IBAction func playBttnPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.LaunchAppventure, bundle: nil)
        let stepViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.Step) as! StepViewController
        stepViewController.appventure = self.newAppventure
        present(stepViewController, animated: true, completion: nil)

    }
    
    @IBAction func shareBttnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.shareWithFriend, sender: self)
    }
    
    @IBAction func publishBttnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Publishing new appventures is currently restricted. If are interested in becoming a contributor. Please contact.....", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func goodForLive() -> String {
        var message = [String]()
        if self.newAppventure.startingLocationName!.characters.count == 0 { message.append("Starting Location") }
        if self.newAppventure.subtitle!.characters.count == 0 { message.append("Description") }
        if self.newAppventure.title!.characters.count == 0 { message.append("Name") }
        if self.newAppventure.appventureSteps.count == 0 { message.append("Steps") }
        let fullMessage = message.joined(separator: ", ")
        return fullMessage
    }
    
    @IBAction func updateSegment(_ sender: UISegmentedControl) {
        let controlValue = sender.selectedSegmentIndex
        switch controlValue {
        case 0:
            navigationItem.rightBarButtonItem = editBarButton
            self.containerView.bringSubview(toFront: detailsView)
        case 1:
            navigationItem.rightBarButtonItem = reorderBarButton
            stepsContainer.isHidden = false
            self.containerView.bringSubview(toFront: stepsContainer)
        case 2:
            navigationItem.rightBarButtonItem = nil
            self.containerView.bringSubview(toFront: mapView)
            tableView.setEditing(false , animated: true)
        default: break
        }
        
    }
    
    //Bar button Actions
    
    func editStepTable(_ sender: AnyObject) {
        navigationItem.rightBarButtonItem = doneBarButton
        tableView.setEditing(true, animated: true)
        segmentControl.isEnabled = false
    }
    
    func doneEditStepTable(_ sender: AnyObject) {
        navigationItem.rightBarButtonItem = reorderBarButton
        tableView.setEditing(false , animated: true)
        segmentControl.isEnabled = true
        AppDelegate.coreDataStack.saveContext(completion: nil)
        tableView.reloadData()
    }
    
    func editDetailsSegue() {
        performSegue(withIdentifier: Constants.editAppventureDetailsSegue, sender: self)
    }
    
    
//MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
      _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.segueNewStep {
            if let row = sender as? Int {
                    if let nvc = segue.destination as? UINavigationController {
                    if let asvc = nvc.childViewControllers[0] as? AddStepTableViewController {
                        if newAppventure.appventureSteps.count > row {
                            let appventureStep = newAppventure.appventureSteps[row]
                            asvc.appventureStep = appventureStep
                        } else {
                            let appventureStep = AppventureStep(appventure: newAppventure)
                            appventureStep.stepNumber = Int16(newAppventure.appventureSteps.count)
                            appventureStep.appventurePFObjectID = newAppventure.backendlessId
                            asvc.appventureStep = appventureStep
                        }
                        asvc.lastLocation = self.lastLocation
                        asvc.delegate = self
                        }
                    }
            }
        }
        
        if segue.identifier == Constants.editAppventureDetailsSegue {
            if let nvc = segue.destination as? UINavigationController {
                if let eadvc = nvc.childViewControllers[0] as? EditAppventureDetailsTableViewController {
                    if newAppventure == nil {
                        newAppventure = Appventure()
//                        CoreUser.user?.ownedAppventures.append(newAppventure)
                    }
                    eadvc.appventure = newAppventure
                    eadvc.delegate = self
                }
            }
        }
        
        if segue.identifier == Constants.shareWithFriend{
            if let nvc = segue.destination as? UINavigationController {
                if let ftvc = nvc.childViewControllers[0] as? FriendsTableViewController {
                    ftvc.appventure = self.newAppventure
                }
            }
        }
    }
    
}


//MARK: - Table 

extension CreateAppventureViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CLLocationCoordinate2DIsValid(newAppventure.location.coordinate) {
            return newAppventure.appventureSteps.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        let row = indexPath.row
        
        if row < newAppventure.appventureSteps.count  {
            let stepCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName) as! AppventureStepTableCell
            if let step = newAppventure.appventureSteps[row] as AppventureStep! {
                stepCell.step = step
                stepCell.setupView()
            }
            cell = stepCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddNewStep")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.segueNewStep, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            confirmDeletePopup(indexPath)
        }
    }
    
    
    // Determine whether a given row is eligible for reordering or not.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true;
    }
    
    // Process the row move. This means updating the data model to correct the item indices.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if sourceIndexPath.row == newAppventure.appventureSteps.count {
            return
        }
        
        let step = newAppventure.appventureSteps[sourceIndexPath.row]
        newAppventure.removeFromSteps(at: sourceIndexPath.row)
        newAppventure.insertIntoSteps(step, at: destinationIndexPath.row)
        
        for (index, step) in newAppventure.appventureSteps.enumerated() {
            step.stepNumber = index + 1
            print("\(step.stepNumber) \(step.nameOrLocation!)")
        }
    }
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Step?", message: "Step data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteStepFromDB(indexPath)
            self.removeFromCoreData(indexPath)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeFromCoreData(_ indexPath: IndexPath) {
        let step = newAppventure.appventureSteps[indexPath.row]
        newAppventure.removeFromSteps(step)
        AppDelegate.coreDataStack.saveContext(completion: nil)
    }
    
    func deleteStepFromDB(_ indexPath: IndexPath) {
        guard let id = newAppventure.appventureSteps[indexPath.row].backendlessId else { return }
        BackendlessStep.removeBy(id: id)
    }

}

//MARK: AppventureDetails Container functions

extension CreateAppventureViewController : AppventureDetailsViewDelegate {
    
    func leftBttnPressed() {
        //show map
    }
    
    func rightBttnPressed(sender: UIButton) {
        self.showProgressView()
        BackendlessAppventure.save(appventure: newAppventure, withImage: true) { 
            self.hideProgressView()
            self.saveComplete()
            UIAlertController.showAlertToast("Saved")
        }
    }
    
    func saveComplete() {
        DispatchQueue.main.async {
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
    }
}

extension CreateAppventureViewController : AddStepTableViewControllerDelegate {
    
    func updateAppventureLocation(_ location: CLLocation) {
        self.newAppventure.location = location
    }
}

extension CreateAppventureViewController  {
    
    func handleQueryResults(_: [AnyObject]?, handlerCase: String?) {
//        self.newAppventure.downloadAndSaveToCoreData(downloadComplete)
    }
    

}

//MARK: Map Location & Map Drawing

extension CreateAppventureViewController: CLLocationManagerDelegate {
    func drawMap() {
        
        if let isAppventure = newAppventure {
            let lat = isAppventure.appventureSteps[0].location!.coordinate.latitude
            let long = isAppventure.appventureSteps[0].location!.coordinate.longitude
            
            var top =  lat + 0.01
            var left =  long - 0.01
            var bottom = lat - 0.01
            var right = long + 0.01
            var totalDistance = 0.0
            var previousLocation = CLLocation(latitude: lat, longitude: long)
            
            //        var bounds = GMSCoordinateBounds()
            self.mapMarkers.removeAll()
            for step in isAppventure.appventureSteps {
                let marker = GMSMarker(position: step.location!.coordinate)
                marker.title = ("\(step.stepNumber): \(step.nameOrLocation)")
                marker.snippet = step.locationSubtitle
                marker.map = self.mapView
                mapMarkers.append(marker)
                
                if marker.position.latitude > top { top = marker.position.latitude }
                if marker.position.latitude < bottom { bottom = marker.position.latitude }
                if marker.position.longitude > right { right = marker.position.longitude }
                if marker.position.longitude < left { left = marker.position.longitude }
                
                //            let northEast = CLLocationCoordinate2DMake(top, right)
                //            let southWest = CLLocationCoordinate2DMake(bottom, left)
                //             bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
                
                //distance calculation
                let currentLocation = CLLocation(latitude: step.location!.coordinate.latitude, longitude: step.location!.coordinate.longitude)
                totalDistance = totalDistance + currentLocation.distance(from: previousLocation)
                previousLocation = currentLocation
            }
            
            isAppventure.totalDistance = totalDistance
            let upD = GMSCameraUpdate.setTarget(isAppventure.appventureSteps[0].location!.coordinate, zoom: 12.0)
            //        let update = GMSCameraUpdate.fitBounds(bounds!)
            
            mapView.moveCamera(upD)
            
        }
        
    }
    
    func getQuickLocationUpdate() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

}

//MARK: = EditAppventureDetailsTableViewControllerDelegate

extension CreateAppventureViewController: EditAppventureDetailsTableViewControllerDelegate{
    func appventureRolledBack() {
        if self.newAppventure.title == "" {
            _ = navigationController?.popViewController(animated: false)
        }
    }
}




