//
//  PasswordToggleVisibilityView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {
    private let eyeOpenedImage: UIImage
    private let eyeClosedImage: UIImage
    private let eyeButton: UIButton
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum EyeState {
        case open
        case closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .open
        }
        get {
            return eyeButton.isSelected ? .open : .closed
        }
    }
    

    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = tintColor
        }
    }
    
    
    init() {
        self.eyeOpenedImage = UIImage(named: "ic_eye_open")!.withRenderingMode(.alwaysTemplate)
        self.eyeClosedImage = UIImage(named: "ic_eye_closed")!
        self.eyeButton = UIButton(type: .custom)
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupViews() {
        
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, for: .normal)
        eyeButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonPressed), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
        
        eyeButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        eyeButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        eyeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        eyeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    
    @objc func eyeButtonPressed(sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(passwordToggleVisibilityView: self, isSelected: eyeButton.isSelected)
    }
}
