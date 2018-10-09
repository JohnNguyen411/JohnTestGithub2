//
//  GridLayoutViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 10/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class GridLayoutViewController: UIViewController {

    override func viewDidLoad() {

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)

        let gridView = GridLayoutView(layout: .common())
        Layout.fill(view: contentView, with: gridView)

        var label = Label.dark(with: "First column")
        gridView.add(subview: label, to: 1)

        var label = Label.dark(with: "Second column")
        gridView.add(subview: label, to: 2)
    }
}
