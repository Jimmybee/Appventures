//
//  AnimatedSegmentControl.swift
//  Appventures
//
//  Created by James Birtwell on 10/05/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//


import UIKit

protocol AnimatedSegmentControlDelegate: class {
    func updatedButton(index: Int)
}

class AnimatedSegmentControl: UIView {
    
    var selectedButton: Int = 0
    var activeBttns = [UIButton]()
    weak var delegate: AnimatedSegmentControlDelegate!
    
    var selectViewVertical : NSLayoutConstraint?
    var selectViewWidth : NSLayoutConstraint?
    var isEnabled: Bool = true {
        didSet {
            activeBttns.forEach({ $0.isEnabled = self.isEnabled })
        }
    }
    
    private(set) var clueTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private(set)  var selectView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Colors.pink
        return view
    }()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    convenience init(bttns: [UIButton], delegate: AnimatedSegmentControlDelegate) {
        self.init(frame: CGRect.zero)
        self.activeBttns = bttns
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    
    override func draw(_ rect: CGRect) {
        setupBttnConstraints()
    }
    
    func setupBttnConstraints() {
        self.addSubview(clueTypeStackView)
        clueTypeStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.addSubview(selectView)
        selectView.autoSetDimension(.height, toSize: 5)
        selectView.autoPinEdge(toSuperviewEdge: .bottom)
        
        selectViewVertical?.autoRemove()
        selectViewWidth?.autoRemove()
        
        
        for (index ,bttn) in activeBttns.enumerated() {
            clueTypeStackView.addArrangedSubview(bttn)
            bttn.tag = index
            bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
            if index > 0 {
                activeBttns[index].autoMatch(.width, to: .width, of: activeBttns[index - 1])
            }
        }
        
        let firstButton = activeBttns[selectedButton]
        firstButton.isSelected = true
        selectViewVertical = selectView.autoAlignAxis(.vertical, toSameAxisOf: firstButton)
        selectViewWidth = selectView.autoMatch(.width, to: .width, of: firstButton, withMultiplier: 0.95)
        
    }
    
    func clueBttnTapped(sender: UIButton) {
        if !isEnabled { return }
        selectViewVertical?.autoRemove()
        
        for bttn in activeBttns {
            bttn.isSelected = false
        }
        activeBttns[sender.tag].isSelected = true
        selectViewVertical!.autoRemove()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.selectViewVertical = self.selectView.autoAlignAxis(.vertical, toSameAxisOf: self.activeBttns[sender.tag])
            self.layoutIfNeeded()
        }, completion: nil)
        
        selectedButton = sender.tag
        delegate.updatedButton(index: sender.tag)
    }
    
    
}
