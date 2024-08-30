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
        NSApp.activate(ignoringOtherApps: true)

        if Defaults[.startMinimized] {
            if let window = NSApp.windows.first {
                window.close()
            }
        } else {
            configureMainWindow()
        }

        AppState.shared.startApp = { [weak self] in
            self?.start()
            AppState.shared.isActive = true
        }

        AppState.shared.stopApp = { [weak self] in
            self?.stop()
            AppState.shared.isActive = false
        }

        if PermissionsManager.getStatus() {
            start()
        }
    }

    private func start() {
        AudioManager.loadSoundPack(Defaults[.soundpack])
        EventManager.setupEventMonitors()
    }

    private func stop() {
        EventManager.removeEventMonitors()
    }

    func applicationWillTerminate(_: Notification) {
        stop()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        if PermissionsManager.getStatus() {
            NSApp.setActivationPolicy(.accessory) // Hide from dock
        }
        return false
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows _: Bool) -> Bool {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        return true
    }
}
