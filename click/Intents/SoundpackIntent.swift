//
//  SoundpackIntent.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import AppIntents

struct SoundpackIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Soundpack"
    static var description = IntentDescription("Choose and apply a different soundpack.")

    @Parameter(title: "Soundpack", description: "The soundpack to apply.")
    var soundpack: Soundpack

    @MainActor
    func perform() async throws -> some IntentResult {
        AudioManager.loadSoundPack(soundpack)
        return .result()
    }
}
