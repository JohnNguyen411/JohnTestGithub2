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

        super.viewDidLoad()
        self.navigationItem.title = "Grid Layout"
        self.view.backgroundColor = .white

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)

        let gridView = GridLayoutView(layout: .common())
        Layout.fill(view: contentView, with: gridView)
        gridView.addDebugSubviewsForMarginsAndGutters()
        gridView.addDebugSubviewsForColumns()

        return;

        var previousView: UIView
        var view: UIView
            
        view = Label.dark(with: "1.1")
        view.backgroundColor = .blue
        gridView.add(subview: view, to: 1)
        view.topAnchor.constraint(equalTo: gridView.topAnchor).isActive = true
        previousView = view

        view = Label.dark(with: "2.2")
        view.backgroundColor = .blue
        gridView.add(subview: view, to: 2)
        view.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
        previousView = view

        Layout.addSpacerView(pinToBottomOf: previousView, pinToSuperviewBottom: true)
    }
}
