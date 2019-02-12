//
//  ImagedLabel.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/11/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ImagedLabel: UIView {
    
    let image = UIImageView(frame: .zero)
    let label = UILabel(frame: .zero)
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.image)
        self.addSubview(self.label)
        
        self.label.font = Font.Small.medium
        self.label.textColor = UIColor.Volvo.volvoBlue
        
        self.image.contentMode = .scaleAspectFit
        self.setConstraints()
    }
    
    convenience init(text: String, image: UIImage) {
        self.init()
        self.label.text = text
        self.image.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String, image: UIImage?) {
        self.label.text = text
        self.image.image = image
    }
    

    private func setConstraints() {
        
        self.image.pinLeadingToView(peerView: self)

        self.image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.label.pinLeadingToView(peerView: self, constant: 30)
        self.label.centerYAnchor.constraint(equalTo: self.image.centerYAnchor)
        
    }
    
}
