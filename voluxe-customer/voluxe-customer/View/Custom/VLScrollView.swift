//
//  VLScrollView.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// VLScrollView is a UIScrollView that is always scrollable, in order to be able to dismiss keyboard if needed
// all the subview will be added to the contentView view
class VLScrollView: UIScrollView {
    
    let contentView = UIView(frame: .zero)
    var scrollViewSize: CGSize? = nil
    
    init() {
        super.init(frame: .zero)
        keyboardDismissMode = .onDrag
        contentMode = .scaleAspectFit
        self.addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        if view == contentView {
            super.addSubview(contentView)
            contentView.frame = self.frame
        } else {
            self.contentView.addSubview(view)
        }
    }
    
    func viewDidLayoutSubviews() {
        if scrollViewSize == nil && self.bounds != .zero {
            contentView.frame = self.bounds
            scrollViewSize = self.frame.size
            self.contentSize = CGSize(width: scrollViewSize!.width, height: scrollViewSize!.height + 4)// make it scrollable
        }
    }
    
}
