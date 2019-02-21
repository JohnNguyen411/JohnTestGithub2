//
//  DriveViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/12/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DriveViewController: RequestStepViewController {
    
    private let directionView = ImagedLabel()
    private let contactTextView = ImagedLabel()
    private let contactCallView = ImagedLabel()
    
    var directionLat: Double?
    var directionLong: Double?
    var directionAddressString: String?

    func addContactButtons(below: UIView) {
        self.addView(self.contactTextView, below: below, spacing: 50)
        self.addView(self.contactCallView, below: self.contactTextView, spacing: 25)
        
        contactTextView.isUserInteractionEnabled = true
        let contactTextTap = UITapGestureRecognizer(target: self, action: #selector(self.textCustomer))
        contactTextView.addGestureRecognizer(contactTextTap)
        
        contactCallView.isUserInteractionEnabled = true
        let contactCallTap = UITapGestureRecognizer(target: self, action: #selector(self.callCustomer))
        contactCallView.addGestureRecognizer(contactCallTap)
        
        directionView.isUserInteractionEnabled = true
        let directionTap = UITapGestureRecognizer(target: self, action: #selector(self.navigateTo))
        directionView.addGestureRecognizer(directionTap)
    }
    
    func addNavigationButton(below: UIView) -> UIView {
        let separator = UIView.forAutoLayout()
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = UIColor.Volvo.fog
        
        self.addView(self.directionView, below: below, spacing: 30)
        
        self.contentView!.addSubview(separator)
        
        separator.pinTopToBottomOf(view: self.directionView, spacing: 20)
        separator.pinLeadingToView(peerView: self.directionView, constant: 30)
        separator.pinTrailingToSuperView(constant: -20)
        
        return self.directionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.directionView.translatesAutoresizingMaskIntoConstraints = false
        self.contactTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contactCallView.translatesAutoresizingMaskIntoConstraints = false
        
        self.directionView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.contactTextView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.contactCallView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if request.hasLoaner {
            let providerKey = NavigationHelper.shared.bestAvailableGPSProvider()
            let providerName = NavigationHelper.shared.providerForKey(providerKey)?.providerName ?? Unlocalized.appleMaps
            directionView.setText("\(Unlocalized.getDirections.uppercased()) (\(providerName.uppercased())", image: UIImage(named: "icon_directions"))
        } else {
            directionView.setText(Unlocalized.copyAddressToClipboard.uppercased(), image: UIImage(named: "icon_directions"))
        }
        
        contactTextView.setText(.localized(.viewContactText), image:  UIImage(named: "icon_text"))
        contactCallView.setText(.localized(.viewContactCall), image:  UIImage(named: "icon_call"))
    }
    
    @objc private func navigateTo() {
        
        guard let lat = self.directionLat, let long = self.directionLong, let address = self.directionAddressString else {
            return
        }
        
        if self.request?.hasLoaner ?? true {
            Analytics.trackClick(button: .getDirections, screen: screenName)
            NavigationHelper.shared.openDefaultGPSProvider(lat: lat, long: long)
        } else {
            // copy address to clipboard
            UIPasteboard.general.string = address
            Analytics.trackClick(button: .getRide, screen: screenName)
            self.requestStepDelegate?.showToast(message: Unlocalized.addressCopiedToClipboard)
        }
        
    }
    
    @objc private func textCustomer() {
        self.contact(mode: "text_only")
        Analytics.trackClick(button: .textCustomer, screen: screenName)
    }
    
    @objc private func callCustomer() {
        self.contact(mode: "voice_only")
        Analytics.trackClick(button: .callCustomer, screen: screenName)
    }
    
    private func contact(mode: String) {
        
        guard let request = self.request else {
            return
        }
        
        if AppController.shared.isBusy() {
            return
        }
        AppController.shared.lookBusy()
        
        DriverAPI.contactCustomer(request, mode: mode, completion: { textNumber, voiceNumber, error in
            AppController.shared.lookNotBusy()
            
            if let error = error {
                AppController.shared.alertGeneric(for: error, retry: false, completion: nil)
                return
            }
            
            if let voiceNumber = voiceNumber, mode == "voice_only" {
                let number = "telprompt:\(voiceNumber)"
                guard let url = URL(string: number) else { return }
                UIApplication.shared.open(url)
            }
            
            if let textNumber = textNumber, mode == "text_only" {
                let number = "sms:\(textNumber)"
                guard let url = URL(string: number) else { return }
                UIApplication.shared.open(url)
            }
            
        })
    }
    
    
    func distanceBetween(driverLocation: CLLocation, destinationLocation: CLLocation) -> CLLocationDistance {
        return AppDelegate.distanceBetween(startLocation:driverLocation, endLocation: destinationLocation)
    }
}
