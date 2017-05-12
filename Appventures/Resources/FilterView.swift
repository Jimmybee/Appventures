//
//  FilterView.swift
//  Appventures
//
//  Created by James Birtwell on 11/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit


class FilterView: UIView {
    static var nib = "FilterView"
    
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: FilterCollectionCell.nibName, bundle: nil)
        filtersCollection.register(nib, forCellWithReuseIdentifier: FilterCollectionCell.nibName)
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        filtersCollection.allowsMultipleSelection = true
    }

}

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filter.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionCell.nibName, for: indexPath) as! FilterCollectionCell
        cell.filterLabel.text = Filter.all[indexPath.row].rawValue
        cell.filterImage.image = Filter.all[indexPath.row].image

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
    }
    
}


enum Filter: String {
    case Outdoor, Family, Puzzle, Night, Museum, Adventurous
    
    var image: UIImage? {
        switch self {
        case .Outdoor:
            return UIImage(named: "v_filter_outdoor")
        case .Family:
            return UIImage(named: "v_filter_family")
        case .Puzzle:
            return UIImage(named: "v_filter_puzzle")
        case .Night:
            return UIImage(named: "v_filter_night")
        case .Museum:
            return UIImage(named: "v_filter_museum")
        case .Adventurous:
            return UIImage(named: "v_filter_adventurous")
        }
    }
    
    static var all: [Filter] {
        return [.Outdoor, .Family, .Puzzle, .Night, .Museum, .Adventurous]
    }
}
