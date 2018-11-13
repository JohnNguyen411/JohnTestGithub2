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
        let gridView = GridLayoutView(layout: .sixColumns())
        Layout.fill(scrollView: scrollView, with: gridView)

        var previousView: UIView
        var view: UIView
            
        view = self.label(with: "1 column wide")
        gridView.add(subview: view, to: 1).pinToSuperviewTop()
        previousView = view

        view = self.label(with: "1 column wide")
        gridView.add(subview: view, to: 2).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.label(with: "6 columns wide")
        gridView.add(subview: view, from: 1, to: 6).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.label(with: "3 columns wide")
        gridView.add(subview: view, from: 1, to: 3).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.label(with: "3 columns wide")
        gridView.add(subview: view, from: 3, to: 5).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.label(with: "2 columns wide")
        gridView.add(subview: view, from: 5, to: 6).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.label(with: "3 columns wide")
        gridView.add(subview: view, from: 1, to: 3).pinTopToBottomOf(view: previousView, spacing: 10)
        view = self.label(with: "3 columns wide")
        gridView.add(subview: view, from: 4, to: 6).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = self.imageView()
        gridView.add(subview: view, from: 1, to: 2).pinTopToBottomOf(view: previousView)
        view = self.imageView()
        gridView.add(subview: view, from: 3, to: 4).pinTopToBottomOf(view: previousView)
        view = self.imageView()
        gridView.add(subview: view, from: 5, to: 6).pinTopToBottomOf(view: previousView)
        previousView = view

        view = self.label(with: "Long caption text that can be used for images")
        gridView.add(subview: view, from: 1, to: 6).pinTopToBottomOf(view: previousView, spacing: 20)
        previousView = view

        view = self.imageView()
        gridView.add(subview: view, from: 1, to: 2).pinTopToBottomOf(view: previousView, spacing: 20)
        view = self.label(with: "Lots of text goes here to demonstrate how text can be positioned next to an image...")
        gridView.add(subview: view, from: 3, to: 6).pinTopToBottomOf(view: previousView, spacing: 20)
        previousView = view

        view = self.label(with: "Really tall label to test scrolling")
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        gridView.add(subview: view, from: 1, to: 6).pinTopToBottomOf(view: previousView, spacing: 10)
        previousView = view

        view = UIView.forAutoLayout()
        view.backgroundColor = Color.Debug.blue
        view.constrain(height: 200)
        gridView.add(subview: view, from: 1, to: 6).pinTopToBottomOf(view: previousView, spacing: 10)
        let label = self.label(with: "Label inside another view but still on grid")
        view.add(subview: label, from: 2, to: 5)
        previousView = view

        // close the subview list with a flexible spacer view
        Layout.addSpacerView(pinToBottomOf: previousView, pinToSuperviewBottom: true)

        // DEBUG
        gridView.addDebugSubviewsForMarginsAndGutters()
        gridView.addDebugSubviewsForColumns()
    }

    private func label(with text: String) -> UIView {
        let view = Label.dark(with: text)
        view.numberOfLines = 5
        view.backgroundColor = Color.Debug.blue
        return view
    }

    private func imageView() -> UIImageView {
        let image = UIImage(named: "image_xc40")
        let view = UIImageView(image: image)
        view.backgroundColor = Color.Debug.blue
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.constrain(height: 50)
        return view
    }
}
