//
//  AppState.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Defaults
import KeyboardShortcuts
import ServiceManagement

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var soundpack: Soundpack = Defaults[.soundpack]
    @Published var isActive = PermissionsManager.getStatus()
    @Published var volumePreset = Defaults[.volumePreset]
    @Published var overrideVolume = Defaults[.overrideVolume]
    @Published var customVolume = Defaults[.customVolume]
    @Published var outputDevice = Defaults[.outputDevice]

    var startApp: (() -> Void)?
    var stopApp: (() -> Void)?

    init() {
        KeyboardShortcuts.onKeyUp(for: .toggle) { [self] in
            toggle()
            NotificationsManager.stateNotification(state: isActive)
        }
    }

    func toggle() {
        if isActive {
            stopApp?()
        } else {
            startApp?()
        }
    }

    func toggleLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to modify login item: \(error.localizedDescription)")
        }
    }
}
