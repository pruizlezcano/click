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
    static let volume = Key<VolumePreset>("volume", default: .balanced)
}
