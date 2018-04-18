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
    var items: [String]
    let singleChoice: Bool
    let selectDefault: Bool
    let topBottomSeparator: Bool

    private(set) var selectedIndices = [Int]()
    
    //MARK: init
    convenience init(items: [String], singleChoice: Bool, selectDefault: Bool, topBottomSeparator: Bool) {
        self.init(singleChoice: singleChoice, selectDefault: selectDefault, topBottomSeparator: topBottomSeparator)
        self.items = items
        setupViews()
    }
    
    init(singleChoice: Bool, selectDefault: Bool, topBottomSeparator: Bool) {
        self.singleChoice = singleChoice
        self.topBottomSeparator = topBottomSeparator
        self.selectDefault = selectDefault
        items = []
        super.init(frame: .zero)
    }
    
    func addItem(item: String) {
        let luxeLabel = VLSelectableLabel(text: item, index: items.count)
        luxeLabel.delegate = self
        luxeLabel.accessibilityIdentifier = "groupedLabel\(items.count)"
        luxeLabel.clipsToBounds = true
        luxeLabel.isUserInteractionEnabled = true
        
        addSubview(luxeLabel)
        
        if items.count > 0 {
            addLabel(luxeLabel: luxeLabel, previousLabel: labels[items.count-1])
        } else {
            addFirstLabel(luxeLabel: luxeLabel)
        }
        
        labels.append(luxeLabel)
        items.append(item)
        
        if self.singleChoice {
            let lastLabel = labels[items.count-1]
            lastLabel.setSelected(selected: true, callDelegate: true)
            selectedIndices.append(items.count-1)
        }
    }
    
    private func setupViews() {
        var previousLabel: VLSelectableLabel?
        
        // add a LuxeSelectableLabel foreach item
        for (index, title) in self.items.enumerated() {
            
            let luxeLabel = VLSelectableLabel(text: title, index: index)
            luxeLabel.delegate = self
            luxeLabel.accessibilityIdentifier = "groupedLabel\(index)"
            luxeLabel.clipsToBounds = true
            luxeLabel.isUserInteractionEnabled = true
            
            addSubview(luxeLabel)
            labels.append(luxeLabel)
            
            if let previousLabel = previousLabel {
                addLabel(luxeLabel: luxeLabel, previousLabel: previousLabel)
            } else {
                addFirstLabel(luxeLabel: luxeLabel)
            }
            
            previousLabel = luxeLabel
        }
        
        /*
        // add last bottom separator
        if let previousLabel = previousLabel, topBottomSeparator {
            addBottomSeparator(previousLabel: previousLabel)
        }
         */
        
        if self.selectDefault {
            let firstLabel = labels[0]
            firstLabel.setSelected(selected: true, callDelegate: false)
            selectedIndices.append(0)
        }
    }
    
    private func addFirstLabel(luxeLabel: VLSelectableLabel) {
        // first label
        luxeLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(VLSelectableLabel.height)
        }
        
        if topBottomSeparator {
            let separator = UIView()
            separator.backgroundColor = .luxeLightGray()
            
            addSubview(separator)
            
            separator.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(luxeLabel.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
            
        }
        addBottomSeparator(previousLabel: luxeLabel)
    }
    
    private func addLabel(luxeLabel: VLSelectableLabel, previousLabel: VLSelectableLabel) {
        // put this label under the previous one
        luxeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(previousLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLSelectableLabel.height)
        }
        
        if topBottomSeparator {
            addBottomSeparator(previousLabel: luxeLabel)
        } else {
            let separator = UIView()
            separator.backgroundColor = .luxeLightGray()
            
            addSubview(separator)
            
            separator.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(luxeLabel.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
    
    private func addBottomSeparator(previousLabel: VLSelectableLabel) {
        let separator = UIView()
        separator.backgroundColor = .luxeLightGray()
        
        addSubview(separator)
        
        separator.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(previousLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
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
    
    func select(selectedIndex: Int, selected: Bool) {
        for (index, view) in labels.enumerated() {
            if selectedIndex == index {
                view.setSelected(selected: selected, callDelegate: true)
            }
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
