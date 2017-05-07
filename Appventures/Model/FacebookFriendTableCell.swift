//
//  FacebookFriendTableCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 01/02/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import PureLayout

class FacebookFriendTableCell: UITableViewCell {
    
    var facebookFriend: UserFriend!
    
    private(set) lazy var profilePictureView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    
    func setupConstraints(){
        contentView.addSubview(profilePictureView)
        contentView.addSubview(nameLabel)
        
        profilePictureView.autoPinEdge(toSuperviewEdge: .left, withInset: 6)
        profilePictureView.autoSetDimension(.width, toSize: 74)
        profilePictureView.autoSetDimension(.height, toSize: 74)
        profilePictureView.autoAlignAxis(toSuperviewAxis: .horizontal)

        nameLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 12), excludingEdge: .left)
        
        profilePictureView.autoPinEdge(.right, to: .left, of: nameLabel)
        
        nameLabel.textAlignment = .right
        
    }
    
    func setupViewContent(){
        
        nameLabel.text = facebookFriend.firstName + " " + facebookFriend.lastName
        if let image = facebookFriend?.profilePicture {
            profilePictureView.image = image
            HelperFunctions.circle(profilePictureView)
        } else {
            profilePictureView.image = nil
            facebookFriend?.loadImageFor(cell: self)
        }
        
        

    }
}
