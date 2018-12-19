//
//  UITableView+OverScroll.swift
//  voluxe-driver
//
//  Created by Christoph on 12/18/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    /// Adds a colored view at the top of the table view's
    /// scroll view, so that when the content offset is <0
    /// (at the top and pulled further) this is the color
    /// that is seen and not the table's background color.
    func addTopOverScrollView(with color: UIColor = .white) {
        let view = UIView.forAutoLayout()
        view.backgroundColor = color
        self.addSubview(view)
        view.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
