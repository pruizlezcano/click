//
//  ClickApp.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

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
    private var activeKeys: Set<UInt16> = []  // Set to track currently pressed keys

    func applicationDidFinishLaunching(_: Notification) {
        print("Starting...")

        if !checkPermissions() {
            AppState.shared.permissionsGranted = false
            showPermissionsWindow()
            startPermissionCheckTimer()
        } else {
            AppState.shared.permissionsGranted = true
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
            hostingController.view.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor),
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
    private func handleEvent(event: NSEvent) {
            switch event.type {
            case .keyDown:
                if !self.activeKeys.contains(event.keyCode) {
                    self.activeKeys.insert(event.keyCode)
                    print("Key pressed: \(event.keyCode)")
                }
            case .flagsChanged:
                print("Key pressed: \(event.keyCode)")
                guard event.modifierFlags.rawValue != 256 || event.keyCode == 57 else { return } // Key released (not caps lock)
            case .keyUp:
                self.activeKeys.remove(event.keyCode)
            default:
                break
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
