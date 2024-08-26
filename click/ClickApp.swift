//
//  ClickApp.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Defaults
import SwiftUI

@main
struct ClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(appState)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        MenuBarExtra("menu-bar", systemImage: "circle.fill") {
            MenuBarView()
                .environmentObject(appState)
        }

        Settings {
            SettingsView()
        }
    }
}
