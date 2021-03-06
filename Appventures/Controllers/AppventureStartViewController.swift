//
//  Alt1AppventureStartViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

protocol AppventureStartDelegate: class {
    func removedJustDownloaded(atIndex: Int)
}

import UIKit
import PureLayout

class AppventureStartViewController: BaseViewController {
    
    struct Constants {
        static let StartAdventureSegue = "StartAdventure"
        static let CellID = "Cell"
    }
    
    lazy var appventure = Appventure()
    var completedAppventures = [CompletedAppventure]()
    var reviews = [Rating]()
    var apiDownloadGroup = DispatchGroup()
    
    weak var delegate: AppventureStartDelegate!
    var index: Int!
    
//    @IBOutlet weak var startAppventure: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var animatedSegmentContainer: UIView!

    @IBOutlet weak var detailsView: UIView!

    var animatedControl: AnimatedSegmentControl!
    
    
    private(set) lazy var detailsSubView: AppventureDetailsView = {
        let bundle = Bundle(for: AppventureDetailsView.self)
        let nib = bundle.loadNibNamed("AppventureDetailsView", owner: self, options: nil)
        let view = nib?.first as? AppventureDetailsView
        return view!
    }()
    
    private(set) lazy var detailsBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.pink, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("DETAILS", for: .normal)
        return bttn
    }()
    
    private(set) lazy var reviewBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.pink, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("REVIEWS", for: .normal)
        return bttn
    }()
    
    private(set) lazy var leaderboardBttn: SegmentButton = {
        let bttn = SegmentButton()
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bttn.setTitleColor(Colors.pink, for: .selected)
        bttn.setTitleColor(.darkGray, for: .normal)
        bttn.setTitle("LEADERBOARD", for: .normal)
        return bttn
    }()
    
    
    //MARK: Controller Lifecyele
    override func viewDidLoad() {
        updateUI()

        //TODO: If a public appventure, then look for ratings and reviews.
//        CompletedAppventure.loadAppventuresCompleted(appventure.pFObjectID!, handler: self)
//        AppventureReviews.loadAppventuresReviews(appventure.pFObjectID!, handler: self)
        HelperFunctions.hideTabBar(self)
        tableView.register(UINib(nibName: CompletedAppventureTableViewCell.cellIdentifierNibName, bundle: nil), forCellReuseIdentifier: CompletedAppventureTableViewCell.cellIdentifierNibName)
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        detailsView.addSubview(detailsSubView)
        detailsSubView.appventure = self.appventure
        detailsSubView.delegate = self
        detailsSubView.autoCenterInSuperview()
        detailsSubView.autoPinEdgesToSuperviewEdges()
        detailsSubView.setup()
        
        getLeaderboard()
        getRatings()

        animatedControl = AnimatedSegmentControl(bttns: [detailsBttn, reviewBttn, leaderboardBttn], delegate: self)
        animatedSegmentContainer.addSubview(animatedControl)
        animatedControl.autoPinEdgesToSuperviewEdges()
        animatedControl.setNeedsDisplay()
        animatedControl.backgroundColor = .white
        
    }
    
    func updateUI () {
        if appventure.downloaded == true {
            startButton.setTitle("Play", for: UIControlState())
        } else {
            startButton.setTitle("Download", for: UIControlState())
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StartAdventureSegue {
            if let svc = segue.destination as? StepViewController {
                svc.appventure = self.appventure
                svc.completedAppventures = self.completedAppventures
            }
        }
    }
    
    /// Popup to remove downloaded appventure
    @IBAction func menuPopUp(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove Downloaded Content", style: .default, handler: { action in
                AppDelegate.coreDataStack.delete(object: self.appventure, completion: { (Void) -> (Void) in
                    DispatchQueue.main.async { () -> Void in
                        let completedRemoval = UIAlertController(title: "Removed", message: "Delete this appventure from your maker profile.", preferredStyle: UIAlertControllerStyle.alert)
                        completedRemoval.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(completedRemoval, animated: true, completion: nil)
                    }
                })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func popController(_ sender: UIBarButtonItem) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: IBActions
   
    @IBAction func downloadAdventure(_ sender: AnyObject) {
        if appventure.downloaded == true {
            performSegue(withIdentifier: Constants.StartAdventureSegue, sender: nil)
        } else {
            downloadAppventure()
        }
    }

    
    //MARK: Image Function
    func halfImage(_ image: UIImage) -> UIImage? {
        if let halfImage = image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 2.0)) as CGImage! {
            return UIImage(cgImage: halfImage)
        }
        return nil
    }
    
}

// MARK: API Methods

extension AppventureStartViewController {
    
    func downloadAppventure() {
        let dataQuery = BackendlessDataQuery()
        let id = appventure.backendlessId
        dataQuery.whereClause = "objectId = '\(id!)'"
        self.showProgressView()
        BackendlessAppventure.loadBackendlessAppventures(persistent: true, dataQuery: dataQuery) { (response, fault) in
            DispatchQueue.main.async {
                guard let appventures = response as? [Appventure] else { return }
                let appventure = appventures.first
                appventure?.downloaded = true
                self.appventure.downloaded = true
                
                CoreUser.user?.insertIntoDownloaded(appventure!, at: 0)
                self.appventure = appventure!

                for step in (appventure?.steps)! {
                    self.apiDownloadGroup.enter()
                    step.loadImage(completion: {
                        self.apiDownloadGroup.leave()
                    })
                }
            }
            
            self.apiDownloadGroup.notify(queue: .main, execute: {
                self.hideProgressView()
                AppDelegate.coreDataStack.saveContext(completion: nil)
                self.startButton.setTitle("Play", for: UIControlState())
                self.delegate.removedJustDownloaded(atIndex: self.index)
            })
            
        }
    }
    
    fileprivate func getLeaderboard() {
        CompletedAppventure.loadLeaderboardFor(appventureId: appventure.backendlessId!) { (completedAppventures) in
            if completedAppventures == nil {
                return
            } else {
                self.completedAppventures = completedAppventures!
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func getRatings() {
        Rating.loadReviews(appventure.backendlessId!, completion: { (ratings) in
            if ratings == nil {
                return
            } else {
                self.reviews = ratings!
                self.tableView.reloadData()
            }
        })
    }
    
}

extension AppventureStartViewController : UITableViewDataSource, UITableViewDelegate {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        switch animatedControl.selectedButton {
        case 1:
            if self.reviews.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
            } else {
                let message = "No one has completed this appventure yet. Be the first!"
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
            return 1
        case 2:
            return 1
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if animatedControl.selectedButton == 1 {
            return self.reviews.count
        } else  {
            return self.completedAppventures.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID) as UITableViewCell!

        switch animatedControl.selectedButton {
        case 1 :
            cell?.textLabel?.text = "Stars: \(reviews[indexPath.row].rating)"
            cell?.detailTextLabel?.text = reviews[indexPath.row].review
        case 2 :
            let completedCell = tableView.dequeueReusableCell(withIdentifier: CompletedAppventureTableViewCell.cellIdentifierNibName) as! CompletedAppventureTableViewCell
            completedCell.appventure = completedAppventures[indexPath.row]
            completedCell.setupCell()
            return completedCell
        default :
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension AppventureStartViewController : AppventureDetailsViewDelegate {
    func leftBttnPressed() {
        let alert = UIAlertController.createDirectionsAlert(coordinate: appventure.location.coordinate, name: appventure.startingLocationName ?? "Start")
        self.present(alert, animated: true, completion: nil)

    }
    
    func rightBttnPressed(sender: UIButton) {
        let textToShare = "Check out this Appventure, \(appventure.title!)"
        if let myWebsite = NSURL(string: "http://www.epicappventures.com/") {
            let objectsToShare: [Any] = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            present(activityVC, animated: true, completion: nil)
        }
        // link to ios share.
    }
}

extension AppventureStartViewController: AnimatedSegmentControlDelegate {
    
    func updatedButton(index: Int) {
        switch animatedControl.selectedButton {
        case 0:
            view.bringSubview(toFront: detailsView)
        case 1:
            view.bringSubview(toFront: tableView)
            tableView.reloadData()
        case 2:
            view.bringSubview(toFront: tableView)
            tableView.reloadData()
        default: break
        }
    }
    
    
}
