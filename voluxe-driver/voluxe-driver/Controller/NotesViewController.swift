//
//  NotesViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/25/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class NotesViewController: UIViewController {
    
    private let notesTextField: UITextView = {
        let field = UITextView()
        field.isEditable = false
        field.backgroundColor = .clear
        field.font = Font.Medium.regular
        return field
    }()
    
    init(title: String, text: String) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = title
        self.notesTextField.text = text
        self.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(notesTextField)
        self.notesTextField.pinLeadingToSuperView(constant: 10)
        self.notesTextField.pinTrailingToSuperView(constant: -10)
        self.notesTextField.pinTopToSuperview(spacing: 0, useSafeArea: true)
        self.notesTextField.pinBottomToSuperview(spacing: 0, useSafeArea: true)
    }
    
}
