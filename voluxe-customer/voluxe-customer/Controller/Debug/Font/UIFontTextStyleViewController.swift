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

        var stylesAndTexts: [(UIFont.TextStyle, String)] = [
            (.title1, "Title 1"),
            (.title2, "Title 2"),
            (.title3, "Title 3"),
            (.headline, "Headline"),
            (.subheadline, "Subheadline"),
            (.body, "Body"),
            (.callout, "Callout"),
            (.caption1, "Caption 1"),
            (.caption2, "Caption 2"),
        ]

        if #available(iOS 11.0, *) {
            stylesAndTexts.insert((.largeTitle, "Large Title"), at: 0)
        }

        var previousLabel: UILabel?
        for styleAndText in stylesAndTexts {
            let label = Label.dark(with: styleAndText.1)
            label.font = styleAndText.0.font
            if previousLabel == nil { Layout.add(subview: label, pinnedToTopOf: contentView) }
            else { Layout.add(view: label, pinTopToBottomOf: previousLabel!) }
            previousLabel = label
        }

        // white space at the bottom of the content view
        Layout.addSpacerView(toBottomOf: contentView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
