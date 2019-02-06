//
//  InspectionNotesViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class InspectionNotesViewController: RequestStepViewController {
    
    private let titleLabel = Label.taskTitle()
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    private let tallLabel = Label.taskText()
    
    private var gridLayoutView: GridLayoutView?
    
    var originalNotes = ""
   
    private let notesTextField: UITextView = {
        let field = UITextView()
        field.isEditable = true
        field.backgroundColor = .clear
        field.textContainer.maximumNumberOfLines = 10
        field.textContainer.lineBreakMode = .byTruncatingTail
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        scrollView.keyboardDismissMode = .onDrag

        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        gridView.clipsToBounds = false
        
        gridView.add(subview: self.titleLabel, from: 1, to: 6)
        self.titleLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.customerLabel, from: 1, to: 6)
        self.customerLabel.pinTopToBottomOf(view: self.titleLabel, spacing: 10)
        
        gridView.add(subview: self.serviceLabel, from: 1, to: 6)
        self.serviceLabel.pinTopToBottomOf(view: self.customerLabel, spacing: 10)
        
        gridView.add(subview: self.notesTextField, from: 1, to: 6)
        self.notesTextField.pinTopToBottomOf(view: self.serviceLabel, spacing: 10)
        self.notesTextField.constrain(height: 120)

        self.gridLayoutView = gridView
        
        self.notesTextField.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gridView = self.gridLayoutView, tallLabel.superview == nil, notesTextField.frame.origin.y > 0 {
            
            let t = self.view.frame.size.height - (notesTextField.frame.origin.y + notesTextField.frame.size.height)
            
            tallLabel.heightAnchor.constraint(equalToConstant: t+2).isActive = true
            gridView.add(subview: tallLabel, from: 1, to: 6).pinTopToBottomOf(view: notesTextField)
            
            Layout.addSpacerView(pinToBottomOf: tallLabel, pinToSuperviewBottom: true)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.titleLabel.text = .localized(.inspectVehicles)
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Small.medium)
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: Font.Small.medium)
            
            if let ro = repairOrders.first, let roNotes = ro.notes {
                self.originalNotes = roNotes
                self.notesTextField.text = roNotes
            }
        }
    }
    
    override func swipeNext(completion: ((Bool) -> ())?) {
        // check if notes are updated, and update them if needed, otherwise just continue
        
        if let repairOrders = self.request?.booking?.repairOrderRequests, repairOrders.count > 0,
            let repairRequest = repairOrders.first, originalNotes != self.notesTextField.text {
            DriverAPI.updateNotes(repairOrderRequestId: repairRequest.id, notes: self.notesTextField.text, completion: { error in
                // TODO handle error and queue
                super.swipeNext(completion: completion)
            })
        } else {
            super.swipeNext(completion: completion)
        }
        
    }
}
