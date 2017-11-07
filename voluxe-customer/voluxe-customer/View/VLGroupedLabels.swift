//
//  VLGroupedLabel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

/**
 Use to create multiple labels with singleChoice selection or multipleChoice
 */
class VLGroupedLabels : UIView, SelectableLabelDelegate {
    
    weak var delegate: VLGroupedLabelsDelegate?
    
    var labels = [VLSelectableLabel]()
    let items: [String]
    let singleChoice: Bool
    
    private(set) var selectedIndices = [Int]()
    
    //MARK: init
    init(items: [String], singleChoice: Bool) {
        self.items = items
        self.singleChoice = singleChoice
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    
    private func setupViews() {
        var previousLabel: VLSelectableLabel?
        
        // add a LuxeSelectableLabel foreach item
        for (index, title) in self.items.enumerated() {
            
            let luxeLabel = VLSelectableLabel(text: title, index: index)
            luxeLabel.delegate = self
            
            addSubview(luxeLabel)
            labels.append(luxeLabel)
            
            if let previousLabel = previousLabel {
                
                // put this label under the previous one
                luxeLabel.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(previousLabel.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(VLSelectableLabel.height)
                }
                
                let separator = UIView()
                separator.backgroundColor = .luxeGray()
                
                addSubview(separator)
                
                separator.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(luxeLabel.snp.top)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(1)
                }
            } else {
                // first label
                luxeLabel.snp.makeConstraints { (make) -> Void in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(VLSelectableLabel.height)
                }
            }
            
            previousLabel = luxeLabel
        }
        
        if self.singleChoice {
            let firstLabel = labels[0]
            firstLabel.setSelected(selected: true, callDelegate: false)
            selectedIndices.append(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: selection action
    func onSelectionChanged(selected: Bool, selectedIndex: Int) {
        delegate?.onSelectionChanged(selected: selected, selectedIndex: selectedIndex)
        
        if singleChoice {
            // if there is already one selected
            if selected && selectedIndices.count > 0 {
                // unselect the other ones
                for (index, view) in labels.enumerated() {
                    if selectedIndex != index {
                        view.setSelected(selected: false, callDelegate: false)
                        setIndexSelected(selected: false, index: index)
                    } else {
                        setIndexSelected(selected: true, index: selectedIndex)
                    }
                }
            } else if !selected && selectedIndices.count <= 1 {
                // keep selected
                let label = labels[selectedIndex]
                label.setSelected(selected: true, callDelegate: false)
                setIndexSelected(selected: true, index: selectedIndex)
            } else {
                setIndexSelected(selected: true, index: selectedIndex)
            }
        } else {
            // multiple choice, just apply the change
            setIndexSelected(selected: selected, index: selectedIndex)
        }
    }
    
    // record the value of selected index in selectedIndices array
    private func setIndexSelected(selected: Bool, index: Int) {
        
        if let indexOf = selectedIndices.index(of: index), !selected {
            selectedIndices.remove(at: indexOf)
        } else if selected && selectedIndices.index(of: index) == nil {
            selectedIndices.append(index)
        }
    }
    
    // return the last selected index
    func getSelectedIndexes() -> Array<Int> {
        return selectedIndices
    }
    
    
    // return the last selected index
    func getLastSelectedIndex() -> Int? {
        return selectedIndices.last
    }
}

// MARK: protocol VLGroupedLabelsDelegate
protocol VLGroupedLabelsDelegate: class {
    func onSelectionChanged(selected: Bool, selectedIndex: Int)
}
