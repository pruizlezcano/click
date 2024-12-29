//
//  AudioManager.swift
//  click
//
//  Created by Pablo Ruiz on 24/8/24.
//

import AVFoundation
import Defaults
import OggDecoder

class AudioManager {
    private static var audioPlayer: AVAudioPlayer?
    private static var audioPlayers: [AVAudioPlayer] = []
    private static var soundpack: Soundpack?

    static func loadSoundPack(_ soundPack: Soundpack, saveState: Bool = true) {
        print("Loading sound: \(soundPack.rawValue).ogg")

        guard let soundURL = Bundle.main.url(forResource: soundPack.rawValue, withExtension: "ogg") else {
            print("Sound not found")
            return
        }

        let decoder = OGGDecoder()
        decoder.decode(soundURL) { savedWavUrl in
            if let savedWavUrl {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: savedWavUrl)
                    if saveState {
                        AppState.shared.soundpack = soundPack
                        Defaults[.soundpack] = soundPack
                    }
                    self.soundpack = soundPack
                    audioPlayers = [AVAudioPlayer]()
                    print("Sound loaded successfully")
                } catch {
                    print("Failed to load sound: \(error.localizedDescription)")
                }
            } else {
                print("Failed to decode OGG file")
            }
        }
    }

    static func playSound(keyCode: UInt16) {
        guard let audioUrl = audioPlayer?.url else { return }
        guard let sound = soundpack?.soundpack?.defines[String(keyCode)] else { return }

        let startTime = TimeInterval(sound![0]) / 1000
        let duration = TimeInterval(sound![1]) / 1000
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            if AppState.shared.outputDevice == .headphones {
                newAudioPlayer.currentDevice = "BuiltInHeadphoneOutputDevice"
            } else if AppState.shared.outputDevice == .speaker {
                newAudioPlayer.currentDevice = "BuiltInSpeakerDevice"
            }

            newAudioPlayer.currentTime = startTime
            if AppState.shared.overrideVolume {
                newAudioPlayer.volume = AppState.shared.customVolume
            } else {
                newAudioPlayer.volume = AppState.shared.volumePreset.volume
            }
            newAudioPlayer.prepareToPlay()
            newAudioPlayer.play()

            audioPlayers.append(newAudioPlayer)

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                newAudioPlayer.stop()
                if let index = audioPlayers.firstIndex(of: newAudioPlayer) {
                    audioPlayers.remove(at: index)
                }
            }
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    static func previewSoundPack(_ soundPack: Soundpack) {
        let soundQueue = DispatchQueue(label: "com.pruizlezcano.click.soundQueue")
        soundQueue.async {
            if AppState.shared.soundpack != soundPack {
                loadSoundPack(soundPack, saveState: false)
                Thread.sleep(forTimeInterval: 0.1)
            }
            let keyCodes = [56, 4, 14, 37, 37, 31, 49, 56, 13, 31, 15, 37, 2, 56, 18] // Hello World!
            let waitTimes = [0.17, 0.28, 0.22, 0.15, 0.16, 0.16, 0.2, 0.1, 0.13, 0.17, 0.2, 0.23, 0.2, 0.21, 0.1]
            for code in 0 ..< keyCodes.count {
                playSound(keyCode: UInt16(keyCodes[code]))
                Thread.sleep(forTimeInterval: waitTimes[code])
            }
            if AppState.shared.soundpack != soundPack {
                loadSoundPack(AppState.shared.soundpack, saveState: false)
            }
        }
    }
}
