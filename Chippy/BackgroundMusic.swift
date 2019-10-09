//
//  BackgroundMusic.swift
//  Chippy Game
//
//  Created by Lars Bergqvist on 2015-09-14.
//  
//

import Foundation
import AVFoundation

class BackGroundMusic : NSObject, AVAudioPlayerDelegate {
    var avPlayer: AVAudioPlayer!
    
    func prepareAudioSession() -> Void {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions(rawValue: UInt(UInt8(AVAudioSession.CategoryOptions.defaultToSpeaker.rawValue)
                | UInt8(AVAudioSession.CategoryOptions.allowAirPlay.rawValue)
                | UInt8(AVAudioSession.CategoryOptions.allowBluetooth.rawValue)
                | UInt8(AVAudioSession.CategoryOptions.allowBluetoothA2DP.rawValue))))
            try AVAudioSession.sharedInstance().setActive(true)
            
            prepareAudioPlayer()
        } catch {
            print(error)
        }
    }
    
    func prepareAudioPlayer() -> Void {
        
        if let soundURL = Bundle.main.url(forResource: "ArturiaMood1", withExtension: "wav") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }
        
        let soundURL = Bundle.main.url(forResource: "ArturiaMood1", withExtension: "wav")
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            if let sound = soundURL{
                try avPlayer = try AVAudioPlayer(contentsOf: sound)
            }
        }
        catch{
            print(error)
        }
        playAudioPlayer()
    }
    
    func playAudioPlayer() -> Void {
        avPlayer.play()
    }
    
    func pauseAudioPlayer() -> Void {
        if avPlayer != nil && avPlayer.isPlaying {
            avPlayer.pause()
        }
    }
    
    func stopAudioPlayer() -> Void {
        
        if avPlayer != nil && avPlayer.isPlaying {
            avPlayer.stop()
        }
    }
    
    func playSound(){
        prepareAudioSession()
    }
    
    func StopSound() {
        stopAudioPlayer()
    }
}
