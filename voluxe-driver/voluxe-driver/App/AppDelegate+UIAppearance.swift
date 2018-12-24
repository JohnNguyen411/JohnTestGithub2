//
//  AppDelegate+UIAppearance.swift
//  voluxe-driver
//
//  Created by Christoph on 12/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {

    func initAppearance() {

        // nav bar
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named: "back_chevron")
        appearance.backIndicatorTransitionMaskImage = appearance.backIndicatorImage
        appearance.backgroundColor = UIColor.Volvo.navigationBar.background
        appearance.isTranslucent = false

        appearance.titleTextAttributes = [NSAttributedString.Key.font: Font.Volvo.h6,
                                          NSAttributedString.Key.foregroundColor: UIColor.Volvo.navigationBar.title]

        // nav bar back indicator
        // note that the back indicator uses the tintColor to color the asset
        var image = UIImage(named: "back_chevron")
        image = image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
        appearance.backIndicatorImage = image
        appearance.backIndicatorTransitionMaskImage = image
        appearance.tintColor = UIColor.Volvo.navigationBar.button

        // nav bar back button title (hidden)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}
