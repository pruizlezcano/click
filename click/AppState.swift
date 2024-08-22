//
//  AppState.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var permissionsGranted = false
    @Published var soundpack: Soundpack?
}
