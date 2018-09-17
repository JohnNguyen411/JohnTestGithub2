//
//  FontTableViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 9/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class StyleGuideViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Style Guide"

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)

        let label0 = Label.dark(with: "Large Title")
        label0.font = Font.TextStyle.largeTitle
        Layout.add(view: label0, toTopOf: contentView)

        let label1 = Label.dark(with: "Title 1")
        label1.font = Font.TextStyle.title1
        Layout.add(view: label1, below: label0)

        let label2 = Label.dark(with: "Title 2")
        label2.font = Font.TextStyle.title2
        Layout.add(view: label2, below: label1)

        let label3 = Label.dark(with: "Title 3")
        label3.font = Font.TextStyle.title3
        Layout.add(view: label3, below: label2)

        let label4 = Label.dark(with: "Headline")
        label4.font = Font.TextStyle.headline
        Layout.add(view: label4, below: label3)

        let label5 = Label.dark(with: "Subheadline")
        label5.font = Font.TextStyle.subheadline
        Layout.add(view: label5, below: label4)

        let label6 = Label.dark(with: "Body")
        label6.font = Font.TextStyle.body
        Layout.add(view: label6, below: label5)

        let label7 = Label.dark(with: "Callout")
        label7.font = Font.TextStyle.callout
        Layout.add(view: label7, below: label6)

        let label8 = Label.dark(with: "Caption 1")
        label8.font = Font.TextStyle.caption1
        Layout.add(view: label8, below: label7)

        let label9 = Label.dark(with: "Caption 2")
        label9.font = Font.TextStyle.caption2
        Layout.add(view: label9, below: label8)

        // white space at the bottom of the content view
        Layout.addSpacerView(toBottomOf: contentView)
    }
}
