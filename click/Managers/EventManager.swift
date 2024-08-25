//
//  EventManager.swift
//  click
//
//  Created by Pablo Ruiz on 24/8/24.
//

import SwiftUI

class EventManager {
    private static var eventMonitor: Any?
    private static var activeKeys: Set<UInt16> = []
    private static let soundQueue = DispatchQueue(label: "com.pruizlezcano.click.soundQueue")

    static func setupEventMonitors() {
        // Global monitor
        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.keyDown, .keyUp, .flagsChanged],
            handler: { event in
                handleEvent(event: event)
            }
        )

        // Local monitor (when the app is focused)
        eventMonitor = NSEvent.addLocalMonitorForEvents(
            matching: [.keyDown, .keyUp, .flagsChanged],
            handler: { event -> NSEvent? in
                handleEvent(event: event)
                if event.modifierFlags.contains(.command) || event.modifierFlags.contains(.function) {
                    // Allow the event to propagate for system shortcuts
                    return event
                }
                return nil // Prevents the 'beep' sound by macOS
            }
        )
    }

    private static func handleEvent(event: NSEvent) {
        soundQueue.async {
            switch event.type {
            case .keyDown:
                if !activeKeys.contains(event.keyCode) {
                    activeKeys.insert(event.keyCode)
                    SoundManager.playSound(keyCode: event.keyCode)
                }
            case .flagsChanged:
                // Return if key released (not caps lock)
                guard event.modifierFlags.rawValue != 256 || event.keyCode == 57 else { return }
                SoundManager.playSound(keyCode: event.keyCode)
            case .keyUp:
                activeKeys.remove(event.keyCode)
            default:
                break
            }
        }
    }

    static func removeEventMonitors() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
