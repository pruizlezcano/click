//
//  ClickApp.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import AVFoundation
import OggDecoder
import SwiftUI

@main
struct ClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(appState)
        .windowStyle(.hiddenTitleBar)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var permissionsWindow: NSWindow?
    private var timer: Timer?
    private var eventMonitor: Any?
    private var audioPlayer: AVAudioPlayer?
    private var audioPlayers: [AVAudioPlayer] = []
    private var activeKeys: Set<UInt16> = [] // Set to track currently pressed keys
    private let soundQueue = DispatchQueue(label: "com.pruizlezcano.click.soundQueue")

    func applicationDidFinishLaunching(_: Notification) {
        print("Starting...")

        if !checkPermissions() {
            AppState.shared.permissionsGranted = false
            showPermissionsWindow()
            startPermissionCheckTimer()
        } else {
            AppState.shared.permissionsGranted = true
            loadSoundPack(Soundpack.egCrystalPurple)

            // Global monitor
            eventMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: [.keyDown, .keyUp, .flagsChanged],
                handler: { event in
                    self.handleEvent(event: event)
                }
            )

            // Local motinor (when the app is focused)
            eventMonitor = NSEvent.addLocalMonitorForEvents(
                matching: [.keyDown, .keyUp, .flagsChanged],
                handler: { event -> NSEvent? in
                    self.handleEvent(event: event)
                    return nil // Prevents the 'beep' sound by macOS
                }
            )
        }
    }

    private func showPermissionsWindow() {
        let permissionsView = PermissionsView()
        let hostingController = NSHostingController(rootView: permissionsView)

        // Create a visual effect view
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow

        // Set the contentView of the visual effect view to the SwiftUI view
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // Create a window
        permissionsWindow = NSWindow()
        permissionsWindow?.contentView = visualEffect
        permissionsWindow?.titlebarAppearsTransparent = true
        permissionsWindow?.styleMask.insert(.closable)
        permissionsWindow?.styleMask.insert(.fullSizeContentView)
        permissionsWindow?.styleMask.insert(.borderless)
        permissionsWindow?.isOpaque = false
        permissionsWindow?.backgroundColor = .clear
        permissionsWindow?.center()
        permissionsWindow?.makeKeyAndOrderFront(nil)

        // Add constraints to make sure the SwiftUI view takes up the entire visual effect view
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor)
        ])
    }

    private func startPermissionCheckTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkAndUpdatePermissions()
        }
    }

    private func checkAndUpdatePermissions() {
        if checkPermissions() {
            AppState.shared.permissionsGranted = true
            print("Accessibility permissions granted!")
            timer?.invalidate()
            permissionsWindow?.close()
        }
    }

    private func loadSoundPack(_ soundPack: Soundpack) {
        print("Loading sound: \(soundPack.rawValue).ogg")

        guard let soundURL = Bundle.main.url(forResource: soundPack.rawValue, withExtension: "ogg") else {
            print("Sound not found")
            return
        }

        let decoder = OGGDecoder()
        decoder.decode(soundURL) { [weak self] savedWavUrl in
            guard let self else { return }

            if let savedWavUrl {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: savedWavUrl)

                    // Assign the sound pack and initialize the audio player array for each keyCode
                    AppState.shared.soundpack = soundPack
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

    private func handleEvent(event: NSEvent) {
        soundQueue.async {
            switch event.type {
            case .keyDown:
                if !self.activeKeys.contains(event.keyCode) {
                    self.activeKeys.insert(event.keyCode)
                    self.playSound(keyCode: event.keyCode)
                }
            case .flagsChanged:
                // Retrun if key released (not caps lock)
                guard event.modifierFlags.rawValue != 256 || event.keyCode == 57 else { return }
                self.playSound(keyCode: event.keyCode)
            case .keyUp:
                self.activeKeys.remove(event.keyCode)
            default:
                break
            }
        }
    }

    private func playSound(keyCode: UInt16) {
        guard let soundpack = AppState.shared.soundpack else { return }
        guard let audioUrl = audioPlayer?.url else { return }
        guard let sound = soundpack.soundpack?.defines[String(keyCode)] else { return }

        let startTime = TimeInterval(sound![0]) / 1000
        let duration = TimeInterval(sound![1]) / 1000
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            newAudioPlayer.currentTime = startTime
            newAudioPlayer.prepareToPlay()
            newAudioPlayer.play()

            // Add the player to the array
            audioPlayers.append(newAudioPlayer)

            // Remove the player from the array after the sound has played
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                newAudioPlayer.stop()
                if let index = self.audioPlayers.firstIndex(of: newAudioPlayer) {
                    self.audioPlayers.remove(at: index)
                }
            }
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}

func checkPermissions() -> Bool {
    if !AXIsProcessTrusted() {
        print("Need accessibility permissions!")
        return false
    } else {
        print("Accessibility permissions active")
        return true
    }
}
