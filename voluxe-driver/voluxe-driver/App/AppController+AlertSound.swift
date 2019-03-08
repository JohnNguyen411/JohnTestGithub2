//
//  AppController+AlertSound.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/13/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

extension AppController: AVAudioPlayerDelegate {
    
    func playAlertSound() {
        if UserDefaults.standard.disableAlertSound { return }

        if let audioPlayer = self.audioPlayer {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1050), {
                AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1050), {
                    AudioServicesPlaySystemSound(SystemSoundID(1050))
                })
            })
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        OSLog.info("audioPlayerDidFinishPlaying")
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print(error)
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        OSLog.info("audioPlayerDecodeErrorDidOccur")
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        OSLog.info("audioPlayerBeginInterruption")
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        OSLog.info("audioPlayerEndInterruption")
    }
}
