//
//  MenuBarView.swift
//  click
//
//  Created by Pablo Ruiz on 25/8/24.
//

import SettingsAccess
import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button {
            appState.toogle()
        } label: {
            if appState.isActive {
                Text("Disable Click")
            } else {
                Text("Enable Click")
            }
        }
        .disabled(!PermissionsManager.getStatus())
        .keyboardShortcut("K", modifiers: [.command, .shift])

        Divider()

        Picker(selection: $appState.volume) {
            ForEach(VolumePreset.allCases, id: \.self) { volume in
                HStack {
                    Text(volume.rawValue.capitalized)
                }
                .tag(volume)
            }
        } label: {
            Image(systemName: "speaker.wave.2")
            Text("Volume")
        }

        Picker(selection: $appState.soundpack) {
            ForEach(Soundpack.allCases, id: \.self) { soundpack in
                HStack {
                    Text(soundpack.soundpack?.name ?? soundpack.rawValue)
                }
                .tag(soundpack)
            }
        } label: {
            Image(systemName: "circle.fill")
            Text("Soundpack")
        }
        .onChange(of: appState.soundpack) { _, newValue in
            AudioManager.loadSoundPack(newValue)
        }

        Divider()

        SettingsLink {
            Text("Settings...")
        } preAction: {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        } postAction: {}
            .keyboardShortcut(",", modifiers: [.command])

        Divider()

        Button {
            NSApplication.shared.terminate(nil)
        } label: {
            Text("Quit")
        }
        .keyboardShortcut("Q", modifiers: [.command])
    }
}

#Preview {
    MenuBarView()
        .environmentObject(AppState.shared)
}
