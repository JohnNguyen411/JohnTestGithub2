//
//  AppController+AlertSound.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/13/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import AVFoundation


extension AppController {

    func playAlertSound() {
        
        if UserDefaults.standard.disableAlertSound { return }
        
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1151), {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1151), {
                AudioServicesPlaySystemSound(SystemSoundID(1151))
            })
        })
    }
}
