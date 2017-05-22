//
//  CreateAppViewController.swift
//  MapPlay
//
//  Created by James Birtwell on 18/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class CreateAppventureViewController: BaseViewController {
    
    struct Constants {
        static let cellName = "StepCell"
        static let segueNewStep = "Add New Step"
        static let editAppventureDetailsSegue = "Edit Appventure Details"
        static let shareWithFriend = "shareWithFriend"
    }
    
    private(set) lazy var detailsSubView: AppventureDetailsView = {
        let bundle = Bundle(for: AppventureDetailsView.self)
        let nib = bundle.loadNibNamed("AppventureDetailsView", owner: self, options: nil)
        let view = nib?.first as? AppventureDetailsView
        view?.delegate = self
        return view!
    }()
    
    private(set) lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(CreateAppventureViewController.editDetailsSegue))
        button.tintColor = .white
        return button
    }()
    private(set) lazy var reorderBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reorder", style: .plain, target: self, action: #selector(CreateAppventureViewController.editStepTable(_:)))
        button.tintColor = .white
        return button
    }()
    private(set) lazy var doneBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateAppventureViewController.doneEditStepTable(_:)))
        button.tintColor = .white
        return button
    }()

    private(set) lazy var detailsBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.purple, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("DETAILS", for: .normal)
        return bttn
    }()
    
    private(set) lazy var stepsBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.purple, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("STEPS", for: .normal)
        return bttn
    }()
    
    private(set) lazy var mapBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.purple, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("MAP", for: .normal)
        return bttn
    }()
    
    var animatedControl = AnimatedSegmentControl()
    
    var aboveBottom: NSLayoutConstraint!
    var belowBottom: NSLayoutConstraint!
    
    // Model
    var newAppventure: Appventure!
    var owner = true
    
    var lastLocation: CLLocation?
    var mapMarkers = [GMSMarker]()
    
    //Process Elements
    var locationManager = CLLocationManager()
    var fethcedStepsController: NSFetchedResultsController<AppventureStep>!

    
    //MARK: Outlets
    //Views
    @IBOutlet weak var stepsContainer: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareBttn: UIButton!
    @IBOutlet weak var publishBttn: UIButton!

    //Constraints
    @IBOutlet weak var stepsTopSegmentBottomCon: NSLayoutConstraint!
    @IBOutlet weak var stepsHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentControlContainer: UIView!

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
    
  
    
//    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFunctions.hideTabBar(self)
        createController()
        
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
        
        if owner {
            setupForOwner()
        } else {
            setupForSharee()
        }
        segmentControlContainer.addSubview(animatedControl)
        animatedControl.backgroundColor = .white
        animatedControl.selectedButton = 0
        animatedControl.selectView.backgroundColor = Colors.purple
        animatedControl.autoPinEdgesToSuperviewEdges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fethcedStepsController == nil { createController() }

        updateUI()
        tableView.reloadData()
        if newAppventure!.appventureSteps.count > 0 {
            drawMap()
        }
    }
    
    fileprivate func setupForOwner() {
        animatedControl = AnimatedSegmentControl(bttns: [detailsBttn, stepsBttn, mapBttn], delegate: self)

    }
    
    fileprivate func setupForSharee() {
        animatedControl = AnimatedSegmentControl(bttns: [detailsBttn], delegate: self)
        editBarButton.isEnabled = false
        shareBttn.isEnabled = false
        publishBttn.isEnabled = false
    }
    
    
    fileprivate func createController() {
        if newAppventure == nil { return }
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let primarySortDescriptor = NSSortDescriptor(key: "stepNumber", ascending: true)
        let fetch:NSFetchRequest<AppventureStep> = AppventureStep.fetchRequest()
        
        fetch.sortDescriptors = [primarySortDescriptor]
        fetch.predicate = NSPredicate(format: "appventure == %@", newAppventure)
        
        fethcedStepsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fethcedStepsController.delegate = self
        do {
            try fethcedStepsController.performFetch()
        } catch {
            print("An error occurred")
        }
        
    }
    
    func stepsLoaded(){
        tableView.reloadData()
    }
    
    //MARK: UI Interface
    
    func updateUI () {
        tableView.reloadData()
        detailsSubView.appventure = self.newAppventure
        detailsSubView.setup()
    }
    
    //MARK: Private functions
    @IBAction func playBttnPressed(_ sender: UIButton) {
        if !newAppventure.isValid() {
            let alert = UIAlertController(title: "PLAY", message: "Complete creating the Appventure before trying to play.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let storyboard = UIStoryboard(name: Storyboards.LaunchAppventure, bundle: nil)
        let stepViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.Step) as! StepViewController
        stepViewController.appventure = self.newAppventure
        present(stepViewController, animated: true, completion: nil)

    }
    
    @IBAction func shareBttnPressed(_ sender: UIButton) {
        if CoreUser.user?.userType == .facebook {
            performSegue(withIdentifier: Constants.shareWithFriend, sender: self)
        } else {
            let alert = UIAlertController(title: "SHARE", message: "Sharing is only supported for facebook connected users", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func publishBttnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Publishing new appventures is currently restricted. If are interested in becoming a contributor. Please contact.....", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goodForLive() -> String {
        var message = [String]()
        if !CLLocationCoordinate2DIsValid(newAppventure.location.coordinate) { message.append("Pick Location")  }
        if self.newAppventure.subtitle!.characters.count == 0 { message.append("Description") }
        if self.newAppventure.title!.characters.count == 0 { message.append("Tagline") }
        if self.newAppventure.appventureSteps.count == 0 { message.append("Steps") }
        let fullMessage = message.joined(separator: ", ")
        return fullMessage
    }
    
    //Bar button Actions
    
    func editStepTable(_ sender: AnyObject) {
        navigationItem.rightBarButtonItem = doneBarButton
        animatedControl.isEnabled = false
        tableView.setEditing(true, animated: true)
    }
    
    func doneEditStepTable(_ sender: AnyObject) {
        navigationItem.rightBarButtonItem = reorderBarButton
        animatedControl.isEnabled = true
        tableView.setEditing(false , animated: true)
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

//MARK: - Fetched Results Delegate 

extension CreateAppventureViewController : NSFetchedResultsControllerDelegate {
    // MARK: NSFetchedResultsControllerDelegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.right)
            }
        case NSFetchedResultsChangeType.delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
        case NSFetchedResultsChangeType.update:
            if let updateIndexPath = indexPath {
//                guard let cell = self.tableView.cellForRow(at: updateIndexPath) as? AppventureStepTableCell else { return }
//                cell.step = fethcedStepsController.object(at: updateIndexPath)
//                cell.setupView()
            }
        case NSFetchedResultsChangeType.move:
            guard let deleteIndexPath = indexPath else { return }
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            
            guard let insertIndexPath = newIndexPath else { return }
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.fade)
            
            tableView.reloadData()
//            AppDelegate.coreDataStack.saveContext(completion: nil)

        }
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}


//MARK: - Table 

extension CreateAppventureViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CLLocationCoordinate2DIsValid(newAppventure.location.coordinate) {
            if let sections = fethcedStepsController.sections {
                let currentSection = sections[section]
                return currentSection.numberOfObjects + 1
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < newAppventure.appventureSteps.count  {
            let stepCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName) as! AppventureStepTableCell
            let step = fethcedStepsController.object(at: indexPath)
            stepCell.step = step
            stepCell.setupView()
            return stepCell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "AddNewStep")!
        }
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
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let count = newAppventure.steps.count
        return indexPath.row == count ? false : true
    }
    
    /// If destination is lower than source, in between steps increase, otherwise decrease e.g row 3, to row 0, would mean, rows 1,2, incease by 1 step number.
    /// Moving from 0 to 2, would reqiure row 1
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        guard let sections = fethcedStepsController.sections,
            var steps = sections[0].objects as? [AppventureStep] else { return }
        
        let step = steps.remove(at: sourceIndexPath.row)
        steps.insert(step, at: destinationIndexPath.row)
        
        for (index, step) in steps.enumerated() {
            step.stepNumber = index + 1
        }

    }
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Step?", message: "Step data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteStepFromDB(indexPath)
            self.removeFromCoreData(indexPath)
            
            guard let sections = self.fethcedStepsController.sections,
                var steps = sections[0].objects as? [AppventureStep] else { return }
            
            for (index, step) in steps.enumerated() {
                step.stepNumber = index + 1
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeFromCoreData(_ indexPath: IndexPath) {
        let step = fethcedStepsController.object(at: indexPath)
        AppDelegate.coreDataStack.delete(object: step, completion: nil)
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
        let message = goodForLive()
        message == "" ? save() : alertNotComplete(message)
        
    }
    
    func save() {
        self.showProgressView()
        BackendlessAppventure.save(appventure: newAppventure) {
            self.hideProgressView()
            DispatchQueue.main.async {
                AppDelegate.coreDataStack.saveContext(completion: nil)
            }
            
            UIAlertController.showAlertToast("Saved")
        }
    }
    
    func alertNotComplete(_ message: String) {
        let alert = UIAlertController(title: "Save", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CreateAppventureViewController : AddStepTableViewControllerDelegate {
    
    func updateAppventureLocation(_ location: CLLocation) {

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
                guard  let nameOrLocation = step.nameOrLocation else { return }
                marker.title = ("\(step.stepNumber): \(nameOrLocation)")
//                marker.snippet = step.locationSubtitle 
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

//MARK: - EditAppventureDetailsTableViewControllerDelegate

extension CreateAppventureViewController: EditAppventureDetailsTableViewControllerDelegate{
    func appventureRolledBack() {
        if self.newAppventure.title == nil {
            _ = navigationController?.popViewController(animated: false)
        }
    }
}


//MARK: - AnimatedSegmentControlDelegate
extension CreateAppventureViewController: AnimatedSegmentControlDelegate {
    
    func updatedButton(index: Int) {
        switch index {
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
}





