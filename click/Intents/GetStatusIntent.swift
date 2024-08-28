//
//  GetStatusIntent.swift
//  click
//
//  Created by Pablo Ruiz on 26/8/24.
//

import AppIntents

struct GetStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Status"
    static var description = IntentDescription("Checks whether Click is currently active")

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        .result(value: AppState.shared.isActive)
    }
}
