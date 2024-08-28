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

    static func loadSoundPack(_ soundPack: Soundpack) {
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
                    AppState.shared.soundpack = soundPack
                    audioPlayers = [AVAudioPlayer]()
                    Defaults[.soundpack] = soundPack
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
        guard let sound = AppState.shared.soundpack.soundpack?.defines[String(keyCode)] else { return }

        let startTime = TimeInterval(sound![0]) / 1000
        let duration = TimeInterval(sound![1]) / 1000
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            newAudioPlayer.currentTime = startTime
            newAudioPlayer.volume = AppState.shared.volume.volume
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
}
