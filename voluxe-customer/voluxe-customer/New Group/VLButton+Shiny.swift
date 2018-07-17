//
//  VLButton+Shiny.swift
//  voluxe-customer
//
//  Created by Christoph on 7/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension VLButton {

    func addShinyAndStartUpdating() {
        let shinyView = VLShinyView(frame: CGRect.zero)
        shinyView.colors = VLShinyView.highlightColors
        self.addSubview(shinyView)
        shinyView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
        shinyView.startUpdates()
//        shinyView.fadeIn()
//        shinyView.layer.masksToBounds = false
    }
}
