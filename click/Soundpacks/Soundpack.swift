//
//  Soundpack.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Defaults
import Foundation

struct SoundpackObject: Decodable {
    let name: String
    let keyDefineType: String
    let includesNumpad: Bool
    let defines: [String: [Int]?]
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case name, defines, tags
        case keyDefineType = "key_define_type"
        case includesNumpad = "includes_numpad"
    }
}

enum Soundpack: String, CaseIterable, Defaults.Serializable {
    case egCrystalPurple = "eg-crysyal-purple"
    case egOreo = "eg-oreo"

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
