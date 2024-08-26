//
//  VolumePreset.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import Defaults

enum VolumePreset: String, CaseIterable, Defaults.Serializable {
    case low
    case balanced
    case loud

    var volume: Float {
        switch self {
        case .low: 0.4
        case .balanced: 1
        case .loud: 2.5
        }
    }
}
