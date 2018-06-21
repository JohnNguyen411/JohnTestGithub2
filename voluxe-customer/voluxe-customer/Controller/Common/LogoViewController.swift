//
//  LogoViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class LogoViewController: BaseViewController {
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "luxeByVolvo")
        return imageView
    }()

    // temporarily disabling shiny logo
    // https://github.com/volvo-cars/ios/issues/263
//    private let shinyViewAlpha = CGFloat(1)
//    let shinyView: ShinyView = {
//        let view = VLShinyView(frame: CGRect.zero)
//        view.axis = .all
//        view.colors = VLShinyView.luxeColors
//        view.scale = 3
//        view.setMask(image: UIImage(named: "luxeByVolvo"))
//        return view
//    }()

    override func setupViews() {
        super.setupViews()
        self.view.addSubview(logo)
        
        var offset: CGFloat = 120.0
        if self.view.hasSafeAreaCapability {
            if let navigationController = self.navigationController {
                offset = 120.0 - (navigationController.navigationBar.frame.height)
            }
            logo.snp.makeConstraints { (make) -> Void in
                make.equalsToTop(view: self.view, offset: offset)
                make.centerX.equalToSuperview()
            }
        } else {
            if let navigationController = self.navigationController {
                offset = 120.0 - (navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.y)
            }
            
            logo.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(offset)
                make.centerX.equalToSuperview()
            }
        }

        // temporarily disabling shiny logo
        // https://github.com/volvo-cars/ios/issues/263
//        self.view.addSubview(self.shinyView)
//        self.shinyView.snp.makeConstraints {
//            (make) -> Void in
//            make.edges.equalTo(logo)
//        }
    }

    // temporarily disabling shiny logo
    // https://github.com/volvo-cars/ios/issues/263
    // Autolayout will not adjust manually added layers,
    // and since the shiny view has a layer mask, this is
    // required to get it to be sized correctly.
//    override func viewDidLayoutSubviews() {
//        self.shinyView.layer.mask?.frame = self.shinyView.layer.bounds
//        self.shinyView.startUpdates()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.shinyView.alpha = 0
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 1) { self.shinyView.alpha = self.shinyViewAlpha }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.shinyView.stopUpdates()
//    }
}
