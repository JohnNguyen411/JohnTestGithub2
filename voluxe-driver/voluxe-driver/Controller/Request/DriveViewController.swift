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
            directionView.setText(.localized(.viewNavigateText), image: UIImage(named: "icon_directions"))
        } else {
            directionView.setText(.localized(.viewGetToText), image: UIImage(named: "icon_directions"))
        }
        
        contactTextView.setText(.localized(.viewContactText), image:  UIImage(named: "icon_text"))
        contactCallView.setText(.localized(.viewContactCall), image:  UIImage(named: "icon_call"))
    }
    
    @objc private func navigateTo() {
        
        guard let lat = self.directionLat, let long = self.directionLong else {
            return
        }
        
        let destinationParam = String(format: "?daddr=%f,%f", lat, long)
        /*
         NSString *defaultGPSApp = [[NSUserDefaults standardUserDefaults] valueForKey:@"default_gps_app"];
         NSInteger gpsAppValue = LuxeGpsAppValueGoogleMaps;
         if (defaultGPSApp) {
         gpsAppValue = [defaultGPSApp integerValue];
         }
         */
        // try to open Google Map Navigation
        let googleMapsTestURL = URL(string: "comgooglemaps-x-callback://")
        
        // if setting is Waze and app installed, launch Waze
        if let wazeTestUrl = URL(string: "waze://"), UIApplication.shared.canOpenURL(wazeTestUrl) {
            // Waze is installed. Launch Waze and start navigation
            guard let url = URL(string: String(format: "waze://?ll=%f,%f&navigate=yes", lat, long)) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            // if setting is Google Maps OR Waze and Google Maps app installed, launch Google Maps
        } else if let mapTestURL = googleMapsTestURL, UIApplication.shared.canOpenURL(mapTestURL) {
            guard let directionsURL = URL(string: "comgooglemaps-x-callback://\(destinationParam)&x-success=sourceapp://?resume=true&x-source=VolvoAgent") else { return }
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
        } else {
            // fallback AppleMap
            guard let directionsURL = URL(string: String(format: "http://maps.apple.com/%@", destinationParam)) else { return }
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func textCustomer() {
        self.contact(mode: "text_only")
    }
    
    @objc private func callCustomer() {
        self.contact(mode: "voice_only")
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
