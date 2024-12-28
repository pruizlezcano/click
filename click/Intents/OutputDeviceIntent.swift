//
//  OutputDeviceIntent.swift
//  click
//
//  Created by Pablo Ruiz on 28/12/24.
//

import AppIntents

struct OutputDeviceIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Output Device"
    static var description = IntentDescription("Choose the output device to use.")

    @Parameter(title: "Device", description: "The output device to use.")
    var outputDevice: OutputDevice

    @MainActor
    func perform() async throws -> some IntentResult {
        AppState.shared.outputDevice = outputDevice
        return .result()
    }
}
