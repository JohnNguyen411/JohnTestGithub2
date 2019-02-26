//
//  UILabelHighlight.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/25/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class UILabelHighlight: UILabel {
    
    let highlightColor: UIColor
    let highlightFont: UIFont?
    
    var textRect: CGRect?
    var attrFrame: CGRect?

    var highlightedAttributedText: NSAttributedString? {
        didSet {
            if highlightedAttributedText != nil {
                self.attributedText = highlightedAttributedText
                if let textRect = self.textRect {
                    self.drawText(in: textRect)
                }
            }
        }
    }
    
    var needToHighlight = true
    
    override var text: String? {
        didSet {
            if text != nil {
                self.needToHighlight = true
            }
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        if let textRect = self.textRect, !self.needToHighlight, self.attributedText != nil {
            return textRect.size
        } else {
            return super.intrinsicContentSize
        }
    }
    
    init(text: String, highlightColor: UIColor, font: UIFont? = nil) {
        self.highlightColor = highlightColor
        self.highlightFont = font
        super.init(frame: .zero)
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        self.textRect = rect
        super.drawText(in: rect)
        self.highlight()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    private func highlight() {
        if !needToHighlight { return }
        
        needToHighlight = false
        let lines = UILabel.getLinesArrayOfString(in: self)
        var lastRange = 0
        var ranges: [NSRange] = []
        let attributedString = NSMutableAttributedString()

        for line in lines {
            attributedString.append(NSMutableAttributedString.highlight(line, with: highlightColor))
            attributedString.append(NSMutableAttributedString.highlight(" ", with: .clear)) // hack
            ranges.append(NSRange(location: lastRange, length: line.count))
            lastRange += line.count
        }
        self.highlightedAttributedText = attributedString
    }
    
}
