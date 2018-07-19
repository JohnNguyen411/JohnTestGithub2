//
//  ShinyViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 7/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ShinyViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white

        let marker = ETAMarker(frame: CGRect(x: 0, y: 0, width: 41, height: 62))
        self.view.addSubview(marker)
        marker.snp.makeConstraints {
            make in
            make.center.equalToSuperview()
        }

//        VLShinyView.metallic().add(to: marker, mask: UIImage(named: "markerDot-mask"))
    }
}
