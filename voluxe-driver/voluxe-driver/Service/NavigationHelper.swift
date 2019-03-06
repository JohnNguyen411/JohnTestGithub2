//
//  NavigationHelper.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/14/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class NavigationHelper {
    
    private let appSupportedProviders: [GPSProvider]
    
    private static let googleMapsScheme = "comgooglemaps-x-callback://"
    private static let wazeScheme = "waze://"

    static let shared = NavigationHelper()
    
    init() {
        appSupportedProviders = [GPSProvider(providerKey: .waze, providerName: .localized(.viewDrawerNavigationPreferenceWaze)),
                                 GPSProvider(providerKey: .googleMaps, providerName: .localized(.viewDrawerNavigationPreferenceGoogle)),
                                 GPSProvider(providerKey: .appleMaps, providerName: Unlocalized.appleMaps)]
    }
    
    func providerForKey(_ key: GPSProvider.ProviderKey) -> GPSProvider? {
        for provider in appSupportedProviders {
            if provider.providerKey == key {
                return provider
            }
        }
         return nil
    }
    
    func bestAvailableGPSProvider() -> GPSProvider.ProviderKey {
        if let preferredGPSProvider = UserDefaults.standard.preferredGPSProvider,
            let gpsProvider = GPSProvider.ProviderKey(rawValue: preferredGPSProvider),
            canOpen(provider: gpsProvider) {
            return gpsProvider
        } else {
            if isWazeSupported() { return .waze }
            if isGoogleMapsSupported() { return .googleMaps }
            return .appleMaps
        }
    }
    
    func deviceSupportedProviders() -> [GPSProvider] {
        var supportedProviders: [GPSProvider] = []
        for provider in appSupportedProviders {
            if provider.providerKey == .waze && isWazeSupported() {
                supportedProviders.append(provider)
            } else if provider.providerKey == .googleMaps && isGoogleMapsSupported() {
                supportedProviders.append(provider)
            } else if provider.providerKey == .appleMaps {
                supportedProviders.append(provider)
            }
        }
        return supportedProviders
    }
    
    func isWazeSupported() -> Bool {
        if let wazeTestUrl = URL(string: NavigationHelper.wazeScheme), UIApplication.shared.canOpenURL(wazeTestUrl) {
            return true
        }
        return false
    }
    
    func isGoogleMapsSupported() -> Bool {
        if let mapTestURL = URL(string: NavigationHelper.googleMapsScheme), UIApplication.shared.canOpenURL(mapTestURL) {
            return true
        }
        return false
    }
    
    func openDefaultGPSProvider(lat: Double, long: Double) {
        let gpsProvider = bestAvailableGPSProvider()
        if gpsProvider == .waze {
            self.openWaze(lat: lat, long: long)
        } else if gpsProvider == .googleMaps {
            self.openGoogleMaps(lat: lat, long: long)
        } else {
            self.openAppleMaps(lat: lat, long: long)
        }
    }
    
    private func canOpen(provider: GPSProvider.ProviderKey) -> Bool {
        if provider == .waze && isWazeSupported() {
            return true
        } else if provider == .googleMaps && isGoogleMapsSupported() {
            return true
        } else if provider == .appleMaps {
            return true
        }
        return false
    }
    
    private func openWaze(lat: Double, long: Double) {
        // Waze is installed. Launch Waze and start navigation
        guard let url = URL(string: String(format: "\(NavigationHelper.wazeScheme)?ll=%f,%f&navigate=yes", lat, long)) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func openGoogleMaps(lat: Double, long: Double) {
        let destinationParam = String(format: "?daddr=%f,%f", lat, long)

        guard let directionsURL = URL(string: "\(NavigationHelper.googleMapsScheme)\(destinationParam)&x-success=sourceapp://?resume=true&x-source=VolvoAgent") else { return }
        UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
    }
    
    private func openAppleMaps(lat: Double, long: Double) {
        let destinationParam = String(format: "?daddr=%f,%f", lat, long)

        guard let directionsURL = URL(string: String(format: "http://maps.apple.com/%@", destinationParam)) else { return }
        UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
    }
    
    
    
}

extension Notification.Name {
    
    struct AgentGPSProvider {
        
        static var providerChanged: Notification.Name {
            return Notification.Name("Notification.AgentGPSProvider.\(#function)")
        }
    }
}

extension Notification {
    static func providerChanged() -> Notification {
        let notification = Notification(name: Notification.Name.AgentGPSProvider.providerChanged)
        return notification
    }
}


struct GPSProvider {
    
    enum ProviderKey: String {
        case waze
        case googleMaps
        case appleMaps
    }
    
    let providerKey: ProviderKey
    let providerName: String
    
    init(providerKey: ProviderKey, providerName: String) {
        self.providerKey = providerKey
        self.providerName = providerName
    }
}
