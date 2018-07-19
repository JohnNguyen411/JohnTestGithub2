//
//  VLButton.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

enum VLButtonType{
    case bluePrimary
    case blueSecondary
    case blueSecondaryWithBorder
    case blueSecondaryWithBorderDisabled
    case blueSecondarySelected
    case whitePrimary
    case orangePrimary
    case orangeSecondary
    case orangeSecondarySmall
    case orangeSecondaryVerySmall
}

class VLButton : UIButton {
    
    static let primaryHeight = 40
    static let secondaryHeight = 30

    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    var iconView: UIImageView?
    var normalBackgroundColor = UIColor.clear
    var highlightBackgroundColor: UIColor?
    var type: VLButtonType?
    var titleText = ""
    let kern: Float?
    
    // Analytics
    // temporary until screenName can be removed
    private var eventName: String? { return self.event?.rawValue }
    private var screenName: String? { return self.screen?.rawValue }
    private var optionalParameters: [String: String]?
    private var event: AnalyticsEnums.Name.Button?
    private var screen: AnalyticsEnums.Name.Screen?
    
    override open var isHighlighted: Bool {
        didSet {
            if let highlightBackgroundColor = highlightBackgroundColor {
                UIView.animate(withDuration: 0.2, animations: {
                    if self.isHighlighted {
                        self.backgroundColor = highlightBackgroundColor
                    } else {
                        self.backgroundColor = self.normalBackgroundColor
                    }
                })
            } else {
                backgroundColor = normalBackgroundColor
            }
        }
    }
    
    var isLoading = false {
        didSet {
            iconView?.animateAlpha(show: !isLoading)
            activityIndicator.animateAlpha(show: isLoading)
            
            if isLoading {
                setTitle(title: "")
                isEnabled = false
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                isEnabled = true
                setTitle(title: titleText)
            }
        }
    }

    /**
     Need to make constraints after initializing the button
     */
    init(type: VLButtonType,
         title: String?,
         kern: Float? = nil,
         actionBlock:(()->())? = nil,
         event: AnalyticsEnums.Name.Button? = nil,
         screen: AnalyticsEnums.Name.Screen? = nil)
    {
        self.kern = kern
        super.init(frame: .zero)

        self.event = event
        self.screen = screen
        setType(type: type)
        
        if let title = title {
            self.titleText = title
            setTitle(title: title)
        }
        
        if let actionBlock = actionBlock {
            setActionBlock(actionBlock: actionBlock)
        }
        
        activityIndicator.isHidden = true
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        if let kern = kern {
            self.addCharacterSpacing(kernValue: kern)
        }
    }
    
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1 : 0.8
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.accessibilityLabel = title
        if let kern = kern {
            self.addCharacterSpacing(kernValue: kern, text: title)
        }
    }

    func setEvent(name: AnalyticsEnums.Name.Button, screen: AnalyticsEnums.Name.Screen? = nil) {
        self.event = name
        self.screen = screen
    }

    func setType(type: VLButtonType) {
        self.type = type
        switch type {
        case .bluePrimary:
            normalBackgroundColor = .luxeDuskBlue()
            highlightBackgroundColor = .luxeLightCobaltBlue()
            backgroundColor = normalBackgroundColor
            applyTextStyle(font: UIFont.volvoSansProBold(size: 14), fontColor: UIColor.luxeWhite(), highlightedFontColor: nil)
            layer.borderWidth = 0
            addShadow()
            break
        case .blueSecondary:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 13), fontColor: UIColor.luxeCobaltBlue(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 0
            break
        case .blueSecondaryWithBorder:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 12), fontColor: UIColor.luxeCobaltBlue(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 1
            layer.borderColor = UIColor.luxeCobaltBlue().cgColor
            break
        case .blueSecondaryWithBorderDisabled:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 12), fontColor: UIColor.luxeGray(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 1
            layer.borderColor = UIColor.luxeGray().cgColor
            break
        case .whitePrimary:
            normalBackgroundColor = .white
            highlightBackgroundColor = .luxeLightestGray()
            backgroundColor = normalBackgroundColor
            applyTextStyle(font: UIFont.volvoSansProBold(size: 14), fontColor: UIColor.luxeCobaltBlue(), highlightedFontColor: nil)
            layer.borderWidth = 0
            addShadow()
            break
        case .orangePrimary:
            normalBackgroundColor = .white
            highlightBackgroundColor = .luxeLightestGray()
            backgroundColor = normalBackgroundColor
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 14), fontColor: UIColor.luxeLipstick(), highlightedFontColor: nil)
            layer.borderWidth = 0
            addShadow()
            break
        case .orangeSecondary:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 18), fontColor: UIColor.luxeLipstick(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 0
            break
        case .orangeSecondarySmall:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 14), fontColor: UIColor.luxeLipstick(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 0
            break
        case .orangeSecondaryVerySmall:
            backgroundColor = .clear
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 12), fontColor: UIColor.luxeLipstick(), highlightedFontColor: .luxeGray())
            layer.borderWidth = 0
            break
        case .blueSecondarySelected:
            normalBackgroundColor = .luxeDuskBlue()
            highlightBackgroundColor = .luxeLightCobaltBlue()
            backgroundColor = normalBackgroundColor
            applyTextStyle(font: UIFont.volvoSansProMedium(size: 12), fontColor: .white, highlightedFontColor: .luxeGray())
            layer.borderWidth = 0
            break
        }
    }
    
    private func applyTextStyle(font: UIFont, fontColor: UIColor, highlightedFontColor: UIColor?) {
        applyTextStyle(font: font, fontColor: fontColor, highlightedFontColor: highlightedFontColor, edgeInsets: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
    }
    
    private func applyTextStyle(font: UIFont, fontColor: UIColor, highlightedFontColor: UIColor?, edgeInsets: UIEdgeInsets) {
        self.titleLabel?.font = font
        self.setTitleColor(fontColor, for: .normal)
        if let highlightedFontColor = highlightedFontColor {
            self.setTitleColor(highlightedFontColor, for: .highlighted)
        }
        self.contentEdgeInsets = edgeInsets
    }
    
    func applyFont(font: UIFont) {
        self.titleLabel?.font = font
    }
    
    func setIcon(named: String?) {
        if let imageView = iconView {
            if let named = named {
                imageView.image = UIImage(named: named)
            } else {
                // remove imageView
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                imageView.removeFromSuperview()
            }
        } else {
            if let named = named {
                let image = UIImageView(image: UIImage(named: named))
                image.frame = CGRect(x: 7, y: 10, width: 20, height: 20)
                image.contentMode = .center
                self.addSubview(image)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.bounds.width * 0.06, bottom: 0, right: 0)
                iconView = image
            } else {
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    private func addShadow() {
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.33
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let iconView = iconView {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.bounds.width*0.06, bottom: 0, right: 0)
            iconView.frame = CGRect(x: self.bounds.width*0.045, y: 10, width: 20, height: 20)
        }
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    /**
     Can use an action block that takes the place of a target/action
     */
    private var actionBlock:(()->())?
    
    //NOTE: Possible memory leak. If you store a button on a view controller with a completion block, you have to use weak self to not cause a retain cycle.
    func setActionBlock(actionBlock:@escaping (()->())) {
        self.actionBlock = actionBlock
        addTarget(self, action: #selector(VLButton.runActionBlock), for: .touchUpInside)
    }

    @objc internal func runActionBlock() {
        if let event = self.event { Analytics.trackClick(button: event, screen: self.screen) }
        actionBlock?()
    }
}
