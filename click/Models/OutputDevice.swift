//
//  OutputDevice.swift
//  click
//
//  Created by Pablo Ruiz on 27/12/24.
//

import AppIntents
import Defaults
import SwiftUI

enum OutputDevice: String, CaseIterable, Defaults.Serializable {
    case speaker
    case headphones
    case any

    var icon: String {
        switch self {
        case .speaker:
            "speaker.fill"
        case .headphones:
            "headphones"
        case .any:
            "speaker.2.fill"
        }
    }
}

extension OutputDevice: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Output Device")
    }

    static var caseDisplayRepresentations: [OutputDevice: DisplayRepresentation] {
        [
            .speaker: DisplayRepresentation(stringLiteral: "Speaker"),
            .headphones: DisplayRepresentation(stringLiteral: "Headphones"),
            .any: DisplayRepresentation(stringLiteral: "Any")
        ]
    }
}
