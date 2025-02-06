//
//  ClickApp.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import AppIntents
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

        MenuBarExtra {
            MenuBarView()
                .environmentObject(appState)
        } label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                $0.isTemplate = true
                return $0
            }(NSImage(named: "MenuIcon")!)

            Image(nsImage: image)
        }

        Settings {
            SettingsView()
        }
        .environmentObject(appState)
    }
}
