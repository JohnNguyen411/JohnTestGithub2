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
    
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    private let tallLabel = Label.taskText()
    private let pickupNotesLabel = Label.taskText(with: "\(String.localized(.viewInspectNotesDescriptionHint)):")

    var originalNotes = ""
   
    private let notesTextField: UITextView = {
        let field = UITextView()
        field.isEditable = true
        field.backgroundColor = .clear
        field.textContainer.maximumNumberOfLines = 10
        field.textContainer.lineBreakMode = .byTruncatingTail
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.Volvo.grey1.cgColor
        field.layer.cornerRadius = 5.0
        field.font = Font.Intermediate.regular
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contentView = self.contentView, let scrollView = self.scrollView else {
            return
        }
        
        scrollView.keyboardDismissMode = .onDrag
        contentView.clipsToBounds = false
        
        self.addViews([self.customerLabel, self.serviceLabel])
        
        self.addView(self.pickupNotesLabel, below: self.serviceLabel, spacing: 20)
        self.addView(self.notesTextField, below: self.pickupNotesLabel, spacing: 10)
        self.notesTextField.constrain(height: 120)
        
        self.notesTextField.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let contentView = self.contentView, tallLabel.superview == nil, notesTextField.frame.origin.y > 0 {
            
            let t = self.view.frame.size.height - (notesTextField.frame.origin.y + notesTextField.frame.size.height)
            
            tallLabel.heightAnchor.constraint(equalToConstant: t+2).isActive = true
            contentView.addSubview(self.tallLabel)
            tallLabel.pinTopToBottomOf(view: notesTextField)
            
            Layout.addSpacerView(pinToBottomOf: tallLabel, pinToSuperviewBottom: true)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.titleLabel.text = .localized(.inspectVehicles)
        self.titleLabel.font = Font.Medium.medium
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: self.intermediateMediumFont())
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: self.intermediateMediumFont())
            
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
