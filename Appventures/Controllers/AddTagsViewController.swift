//
//  AddTagsViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class AddTagsViewController: UIViewController {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    var appventure: Appventure!
    
    let commonTags = CommonTags.all
    
    override func viewDidLoad() {
        let layout = tagCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 40, height: 30)
    }
    
}

extension AddTagsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return commonTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commonTags[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddTagsCell
        let title = commonTags[indexPath.section][indexPath.row].rawValue
        appventure.tags.contains(title) ? turnOn(bttn: cell.tagBttn, title: title) : turnOff(bttn: cell.tagBttn)

        cell.tagBttn.layer.cornerRadius = 10
        cell.tagBttn.layer.borderWidth = 1
        cell.tagBttn.layer.borderColor = UIColor.darkGray.cgColor
        cell.tagBttn.setTitle(title, for: .normal)
        cell.tagBttn.showsTouchWhenHighlighted = false
        
        cell.delegate = self
        return cell
    }

    func turnOn(bttn: UIButton, title: String) {
        let commonTag = CommonTags(rawValue: title)
        bttn.setTitleColor(.white, for: .normal)
        bttn.backgroundColor = commonTag?.color
    }
    
    func turnOff(bttn: UIButton) {
        bttn.setTitleColor(.black, for: .normal)
        bttn.backgroundColor = .clear
    }
}

extension AddTagsViewController: AddTagsCellDelegate {
    func tagBttnTapped(bttn: UIButton) {
        guard let title = bttn.titleLabel?.text else { return }
        if appventure.tags.contains(title) {
            appventure.tags.remove(title)
            turnOff(bttn: bttn)
        } else {
            appventure.tags.insert(title)
            turnOn(bttn: bttn, title: title)
        }
    }
}

enum CommonTags: String {
    case easy
    case medium
    case hard
    case family
    case adult
    case short
    case long
    case epic
    
    var color: UIColor {
        switch self {
        case .easy:
            return Colors.brightGreen
        case .medium:
            return Colors.brightGreen
        case .hard:
            return Colors.brightGreen
        case .family:
            return Colors.brightPurple
        case .adult:
            return Colors.brightPurple
        case .short:
            return Colors.brightBlue
        case .long:
            return Colors.brightBlue
        case .epic:
            return Colors.brightBlue
        }
    }
    
    static let all = [difficulty, type, length]
    static let difficulty = [easy, medium, hard]
    static let type = [family, adult]
    static let length = [short, long, epic]
}
