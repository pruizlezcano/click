//
//  ToogleIntent.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import AppIntents

struct ToggleEventMonitorIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Click"
    static var description = IntentDescription("Toggle the Click sound on and off.")

    @MainActor
    func perform() async throws -> some IntentResult {
        AppState.shared.toggle()
        return .result()
    }
}
