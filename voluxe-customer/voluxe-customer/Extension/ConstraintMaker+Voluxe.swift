//
//  ConstraintMaker+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

extension ConstraintMaker {
    
    func edgesEqualsToView(view: UIView) {
        edgesEqualsToView(view: view, edges: UIEdgeInsets.zero)
    }
    
    func edgesEqualsToView(view: UIView, edges: UIEdgeInsets) {
        self.left.equalTo(view.safeArea.left).inset(edges.left)
        self.right.equalTo(view.safeArea.right).inset(edges.right)
        self.top.equalTo(view.safeArea.top).inset(edges.top)
        self.bottom.equalTo(view.safeArea.bottom).inset(edges.bottom)
    }
    
    func equalsToBottom(view: UIView, offset: ConstraintOffsetTarget) {
        self.bottom.equalTo(view.safeArea.bottom).offset(offset)
    }
    
    func equalsToTop(view: UIView) {
        self.top.equalTo(view.safeArea.top)
    }
    
    func equalsToTop(view: UIView, offset: ConstraintOffsetTarget) {
        self.top.equalTo(view.safeArea.top).offset(offset)
    }
    
    
}
