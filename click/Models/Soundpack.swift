//
//  Soundpack.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import AppIntents
import Defaults
import Foundation

struct SoundpackObject: Decodable {
    let name: String
    let manufacturer: String
    let defines: [String: [Int]?]
}

enum Soundpack: String, CaseIterable, Defaults.Serializable {
    case egCrystalPurple = "eg-crysyal-purple"
    case egOreo = "eg-oreo"
    case nkCream = "nk-cream"

    var soundpack: SoundpackObject? {
        loadJSON(rawValue)
    }
}

private func loadJSON(_ soundpack: String) -> SoundpackObject? {
    guard let url = Bundle.main.url(forResource: soundpack, withExtension: "json") else {
        print("Failed to find URL for resource: \(soundpack).json")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let soundpackObject = try decoder.decode(SoundpackObject.self, from: data)
        return soundpackObject
    } catch {
        print("Failed to load or decode JSON: \(error.localizedDescription)")
        return nil
    }
}

extension Soundpack: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Soundpack")
    }

    static var caseDisplayRepresentations: [Soundpack: DisplayRepresentation] {
        [
            .egCrystalPurple: DisplayRepresentation(stringLiteral: "EG Crystal Purple"),
            .egOreo: DisplayRepresentation(stringLiteral: "EG Oreo"),
            .nkCream: DisplayRepresentation(stringLiteral: "NK Cream")
        ]
    }
}
