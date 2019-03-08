//
//  UITextViewHighlight.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/25/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class UITextViewHighlight: UITextView, NSLayoutManagerDelegate {

    let highlightColor: UIColor
    let lineSpacing: CGFloat
    var lineNumbers: [Int: CGFloat] = [:]

    init(_ text: String? = nil, highlightColor: UIColor, lineSpacing: CGFloat) {
        self.highlightColor = highlightColor
        self.lineSpacing = lineSpacing
        super.init(frame: .zero, textContainer: nil)
        self.isEditable = false
        self.backgroundColor = .clear
        self.layoutManager.delegate = self
        if let text = text {
            self.text = text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        guard let txt = self.text else {
            return
        }
        let textRange = NSRange(location: 0, length: txt.count)
        
        self.layoutManager.enumerateLineFragments(forGlyphRange: textRange) { (rect, usedRect, _, _, _) in
            var bgRect = usedRect
            bgRect.origin.y += (self.lineSpacing + 9)
            bgRect.size.height -= self.lineSpacing
            let bezierPath = UIBezierPath(rect: bgRect)
            self.highlightColor.setFill()
            bezierPath.fill()
            bezierPath.close()
        }
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return self.lineSpacing
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       shouldUse action: NSLayoutManager.ControlCharacterAction,
                       forControlCharacterAt charIndex: Int) -> NSLayoutManager.ControlCharacterAction {
        return .lineBreak
    }
    
    
}
