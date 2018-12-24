//
//  Button.swift
//  voluxe-driver
//
//  Created by Christoph on 12/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

protocol Buttons {
    func primary(title: String) -> UIButton
    func secondary(title: String) -> UIButton
}

// TODO connect with ButtonColors
class VolvoButtons: Buttons {

    func primary(title: String) -> UIButton {
        let button = UIButton(color: UIColor.Volvo.volvoBlue,
                              disabledColor: UIColor.Volvo.fog,
                              cornerRadius: 2)
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.Volvo.shadow.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }

    func secondary(title: String) -> UIButton {
        let button = UIButton(color: UIColor.Volvo.white,
                              cornerRadius: 2)
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.Volvo.shadow.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.setTitleColor(UIColor.Volvo.cloudBerry, for: .normal)
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }

    func text(title: String) -> UIButton {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setTitleColor(UIColor.Volvo.volvoBlue, for: .normal)
        button.setTitle(title.uppercased(), for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }
}

extension UIButton {
    static let Volvo = VolvoButtons()
}
