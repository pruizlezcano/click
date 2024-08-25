//
//  AppState.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var soundpack: Soundpack?
    @Published var isActive = PermissionsManager.getStatus()

    var startApp: (() -> Void)?
    var stopApp: (() -> Void)?

    func toogle() {
        if isActive {
            stopApp?()
        } else {
            startApp?()
        }
    }
}
