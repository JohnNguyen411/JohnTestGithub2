//
//  UIView+Toast.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/19/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

enum ToastPosition {
    case top
    case center
    case bottom
}

//MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView
{
    func showToast(toastMessage: String, duration: Double, font: UIFont? = nil, position: ToastPosition = .center)
    {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            topPadding = window.safeAreaInsets.top
            bottomPadding = window.safeAreaInsets.bottom
        }
        
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: window.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555

        //Label For showing toast text
        let lblMessage = ToastLabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        lblMessage.textAlignment = .center
        if let font = font {
            lblMessage.font = font
        } else {
            lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        }
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width - 24, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        
        var y = (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2)
        
        if position == .top {
            y = ((expectedSizeTitle.height + 16 ) / 2) + (60 + topPadding)
        } else if position == .bottom {
            y = (self.bounds.size.height - ((expectedSizeTitle.height + 16 ) / 2 + (60 + bottomPadding)))
        }
        
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: y, width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        window.addSubview(bgView)
        lblMessage.alpha = 0
        bgView.alpha = 0
        
        bgView.isUserInteractionEnabled = true
        let bgTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissToast))
        bgTap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(bgTap)
        
        UIView.animateKeyframes(withDuration: TimeInterval(0.30) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
            bgView.alpha = 1
        }, completion: {
            sucess in
            if bgView.superview == nil { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: { [weak self] in
                if bgView.superview == nil { return }
                self?.dismissToast()
            })
        })
    }
    
    
    @objc func dismissToast() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        guard let view = window.viewWithTag(555) else { return }
        
        UIView.animate(withDuration: TimeInterval(0.30), delay: 0, options: [] , animations: {
            view.alpha = 0
        }, completion: {
            sucess in
            view.removeFromSuperview()
        })

    }
    
}

extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

fileprivate class ToastLabel: UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}
