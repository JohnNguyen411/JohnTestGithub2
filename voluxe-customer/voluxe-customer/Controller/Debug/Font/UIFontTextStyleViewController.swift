//
//  FontTableViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 9/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class UIFontTextStyleViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "UIFont.TextStyle"

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)

        let fontsAndTexts: [(UIFont, String)] = [
            (Font.TextStyle.largeTitle, "Large Title"),
            (Font.TextStyle.title1, "Title 1"),
            (Font.TextStyle.title2, "Title 2"),
            (Font.TextStyle.title3, "Title 3"),
            (Font.TextStyle.headline, "Headline"),
            (Font.TextStyle.subheadline, "Subheadline"),
            (Font.TextStyle.body, "Body"),
            (Font.TextStyle.callout, "Callout"),
            (Font.TextStyle.caption1, "Caption 1"),
            (Font.TextStyle.caption2, "Caption 2"),
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
