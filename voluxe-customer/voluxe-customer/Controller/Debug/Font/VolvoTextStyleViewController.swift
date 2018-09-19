//
//  VolvoTextStyleViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 9/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VolvoTextStyleViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Volvo Text Styles"

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)

        let fontsAndTexts: [(UIFont, String)] = [
            (Font.Volvo.h1, "H1"),
            (Font.Volvo.h2, "H2"),
            (Font.Volvo.h3, "H3"),
            (Font.Volvo.h4, "H4"),
            (Font.Volvo.h5, "H5"),
            (Font.Volvo.h6, "H6"),
            (Font.Volvo.subtitle1, "Subtitle 1"),
            (Font.Volvo.subtitle2, "Subtitle 2"),
            (Font.Volvo.body1, "Body 1"),
            (Font.Volvo.body2, "Body 2"),
            (Font.Volvo.button, "BUTTON"),
            (Font.Volvo.caption, "Caption"),
            (Font.Volvo.overline, "OVERLINE"),
        ]

        var previousLabel: UILabel?
        for fontAndText in fontsAndTexts {
            let label = Label.dark(with: fontAndText.1)
            label.font = fontAndText.0
            if previousLabel == nil { Layout.add(view: label, toTopOf: contentView) }
            else { Layout.add(view: label, below: previousLabel!) }
            previousLabel = label
        }

        // white space at the bottom of the content view
        Layout.addSpacerView(toBottomOf: contentView)
    }
}
