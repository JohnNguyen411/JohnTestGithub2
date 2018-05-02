//
//  UINavigationController+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/10/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func setTitle(title: String?) {
        if let title = title {
            self.title = title
            self.navigationItem.title = title
            self.navigationBar.topItem?.title = title
        }
    }
}
