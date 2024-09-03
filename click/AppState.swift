//
//  AppState.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Defaults
import ServiceManagement

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var soundpack: Soundpack = Defaults[.soundpack]
    @Published var isActive = PermissionsManager.getStatus()
    @Published var volumePreset = Defaults[.volumePreset]
    @Published var overrideVolume = Defaults[.overrideVolume]
    @Published var customVolume = Defaults[.customVolume]

    var startApp: (() -> Void)?
    var stopApp: (() -> Void)?

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
