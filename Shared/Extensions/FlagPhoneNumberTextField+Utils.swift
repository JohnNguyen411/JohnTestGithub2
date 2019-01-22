//
//  FlagPhoneNumberTextField+Utils.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 12/3/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import FlagPhoneNumber
import libPhoneNumber_iOS

extension FPNTextField {
    
    public func getValidNumber(phoneNumber: String, countryCode: String) -> NBPhoneNumber? {
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else { return nil }

        do {
            let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: countryCode)
            let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
            
            return isValid ? parsedPhoneNumber : nil
        } catch _ {
            return nil
        }
    }
    
    public func getDefaultCountryCode() -> String? {
        if let regionCode = Locale.current.regionCode, let countryCode = FPNCountryCode(rawValue: regionCode) {
            return countryCode.rawValue
        } else {
            return FPNCountryCode(rawValue: "US")?.rawValue
        }
    }
    
    public static func getCountryCode(phoneNumber: String) -> NSNumber? {
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else { return nil }

        do {
            let phoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: "")
            return phoneNumber.countryCode
        } catch {
            return nil
        }
    }
    
    public func getInputPhoneNumber() -> String? {
        if let rawPhone = self.getRawPhoneNumber() {
            return rawPhone
        }
        return self.text
    }
    
    public func setFlagForPhoneNumber(phoneNumber: String?) {
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else { return }
        if let phoneNumber = phoneNumber, let countryCode = FPNTextField.getCountryCode(phoneNumber: phoneNumber) {
            if let regionCode = phoneUtil.getRegionCode(forCountryCode: countryCode), let fpnCountryCode = FPNCountryCode.init(rawValue: regionCode) {
                self.setFlag(for: fpnCountryCode)
            }
        }
    }
    
    
}
