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
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(logo)
        
        var offset: CGFloat = 120.0
        if let navigationController = self.navigationController {
            offset = 120.0 - navigationController.navigationBar.frame.height
        }
        
        logo.snp.makeConstraints { (make) -> Void in
            make.equalsToTop(view: self.view, offset: offset)
            make.centerX.equalToSuperview()
        }
    }
}
