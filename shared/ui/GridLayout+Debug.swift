//
//  GridLayout+Debug.swift
//  voluxe-customer
//
//  Created by Christoph on 10/11/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension GridLayoutView {

    func addDebugSubviewsForMarginsAndGutters() {

        let debugView = UIView.forAutoLayout()
        debugView.isUserInteractionEnabled = false
        Layout.fill(view: self, with: debugView)

        for guide in self.guides {
            let view = UIView.forAutoLayout()
            view.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.1)
            debugView.addSubview(view)
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        }
    }

    func addDebugSubviewsForColumns() {

        let debugView = UIView.forAutoLayout()
        debugView.isUserInteractionEnabled = false
        Layout.fill(view: self, with: debugView)

        for i in 1...self.gridLayout.columnCount {
            let leadingGuide = self.guides[Int(i - 1)]
            let trailingGuide = self.guides[Int(i)]
            let view = UIView.forAutoLayout()
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            debugView.addSubview(view)
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingGuide.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor).isActive = true
        }
    }
}
