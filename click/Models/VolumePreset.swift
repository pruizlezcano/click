//
//  VolumePreset.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import AppIntents
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

extension VolumePreset: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Soundpack")
    }

    static var caseDisplayRepresentations: [VolumePreset: DisplayRepresentation] {
        [
            .low: DisplayRepresentation(stringLiteral: "Low"),
            .balanced: DisplayRepresentation(stringLiteral: "Balanced"),
            .loud: DisplayRepresentation(stringLiteral: "Loud")
        ]
    }
}
