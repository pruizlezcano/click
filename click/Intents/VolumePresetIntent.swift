//
//  VolumePresetIntent.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import AppIntents

struct VolumePresetIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Volume Preset"
    static var description = IntentDescription("Adjusts Click volume to a predefined level.")

    @Parameter(title: "Volume", description: "The volume preset to use.")
    var volumePreset: VolumePreset

    @MainActor
    func perform() async throws -> some IntentResult {
        AppState.shared.volume = volumePreset
        return .result()
    }
}
