//
//  CustomVolumeIntent.swift
//  click
//
//  Created by Pablo Ruiz on 3/9/24.
//

import AppIntents

struct CustomVolumeIntent: AppIntent {
    static var title: LocalizedStringResource = "Set volume"
    static var description = IntentDescription("Adjusts Click volume to a custom level.")

    @Parameter(title: "Volume", description: "The volume to set.")
    var volume: Int

    @MainActor
    func perform() async throws -> some IntentResult {
        AppState.shared.customVolume = Float(volume)
        AppState.shared.overrideVolume = true
        return .result()
    }
}
