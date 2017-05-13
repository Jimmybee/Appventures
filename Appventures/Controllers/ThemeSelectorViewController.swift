//
//  ThemeSelectorViewController.swift
//  Appventures
//
//  Created by James Birtwell on 13/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class ThemeSelectorViewController: UIViewController {
    
    var appventure: Appventure!
    var activeThemes = Set<Filter>()
    
    
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    override func viewDidLoad() {
        setupCollectionView()
        
        addTheme(theme: appventure.themeOne)
        addTheme(theme: appventure.themeTwo)
    }
    
    func addTheme(theme: String?) {
        if let theme = theme,
            let filter = Filter(rawValue: theme) {
            activeThemes.insert(filter)
        }
    }
    
    
    
    func setupCollectionView() {
        let nib = UINib(nibName: FilterCollectionCell.nibName, bundle: nil)
        filtersCollection.register(nib, forCellWithReuseIdentifier: FilterCollectionCell.nibName)
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.allowsSelection = true
    }
    
}

extension ThemeSelectorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filter.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionCell.nibName, for: indexPath) as! FilterCollectionCell
        let filter = Filter.all[indexPath.row]
        
        cell.filterLabel.text = filter.rawValue
        cell.filterImage.image = filter.image
        cell.filterImage.tintColor = Colors.purple
        
        if !activeThemes.contains(filter) {
            cell.filterImage.alpha = 0.6
            cell.filterLabel.alpha = 0.6
        } else {
            cell.filterImage.alpha = 1
            cell.filterLabel.alpha = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let theme = Filter.all[indexPath.row]
        if activeThemes.contains(theme) {
            activeThemes.remove(theme)
        } else {
            if activeThemes.count == 2 { return
            }
            activeThemes.insert(theme)
        }
        
        mapThemesToAppventure()
        filtersCollection.reloadData()
    }
    
    func mapThemesToAppventure() {
        appventure.themeOne = nil
        appventure.themeTwo = nil
        
        for (index, theme) in activeThemes.enumerated() {
            if index == 0 {
                appventure.themeOne = theme.rawValue
            } else {
                appventure.themeTwo = theme.rawValue
            }
        }
    }
    
    
}
