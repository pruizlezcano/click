//
//  Defaults.swift
//  click
//
//  Created by Pablo Ruiz on 23/8/24.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let soundpack = Key<Soundpack>("soundpack", default: .egCrystalPurple)
    static let launchAtLogin = Key<Bool>("launchAtLogin", default: false)
    static let startMinimized = Key<Bool>("startMinimized", default: false)
    static let volumePreset = Key<VolumePreset>("volume", default: .balanced)
    static let overrideVolume = Key<Bool>("overrideVolume", default: false)
    static let customVolume = Key<Float>("customVolume", default: 1)
    static let showNotifications = Key<Bool>("showNotifications", default: true)
    static let outputDevice = Key<OutputDevice>("outputDevice", default: .any)
}
