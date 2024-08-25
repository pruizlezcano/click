//
//  AppDelegate.swift
//  click
//
//  Created by Pablo Ruiz on 24/8/24.
//

import AVFoundation
import Defaults
import OggDecoder
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var permissionsWindow: NSPanel?
    private var timer: Timer?
    private var eventMonitor: Any?
    private var audioPlayer: AVAudioPlayer?
    private var audioPlayers: [AVAudioPlayer] = []
    private var activeKeys: Set<UInt16> = [] // Set to track currently pressed keys
    private let soundQueue = DispatchQueue(label: "com.pruizlezcano.click.soundQueue")

    private func configureMainWindow() {
        if let window = NSApp.windows.first {
            let visualEffect = NSVisualEffectView()
            visualEffect.blendingMode = .behindWindow
            visualEffect.state = .active
            visualEffect.material = .hudWindow

            // Set the contentView of the visual effect view to the SwiftUI view
            visualEffect.translatesAutoresizingMaskIntoConstraints = false
            visualEffect.addSubview(window.contentView!)
            window.contentView = visualEffect
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.closable)
            window.styleMask.insert(.fullSizeContentView)
            window.styleMask.insert(.borderless)
            window.isOpaque = false
            window.backgroundColor = .clear
            window.center()
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.makeKeyAndOrderFront(nil)
        }
    }

    func applicationDidFinishLaunching(_: Notification) {
        print("Starting...")

        configureMainWindow()

        AppState.shared.startApp = { [weak self] in
            self?.start()
        }

        if !PermissionsManager.getStatus() {
            AppState.shared.permissionsGranted = false
        } else {
            start()
        }
    }

    private func start() {
        AppState.shared.permissionsGranted = true
        SoundManager.loadSoundPack(Defaults[.soundpack])
        EventManager.setupEventMonitors()
    }

    func applicationWillTerminate(_: Notification) {
        EventManager.removeEventMonitors()
    }
}
