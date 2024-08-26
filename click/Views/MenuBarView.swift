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

        Menu {
            ForEach(VolumePreset.allCases, id: \.self) { volume in
                Button {
                    appState.volume = volume
                } label: {
                    if volume == appState.volume {
                        Image(systemName: "checkmark")
                    }
                    Text(volume.rawValue.capitalized)
                }
            }
        } label: {
            Image(systemName: "speaker.wave.2")
            Text("Volume")
        }

        Menu {
            ForEach(Soundpack.allCases, id: \.self) { soundpack in
                Button {
                    AudioManager.loadSoundPack(soundpack)
                } label: {
                    if soundpack == appState.soundpack {
                        Image(systemName: "checkmark")
                    }
                    Text(soundpack.soundpack?.name ?? soundpack.rawValue)
                }
            }
        } label: {
            Image(systemName: "circle.fill")
            Text("Soundpack")
        }

        Divider()

        SettingsLink {
            Text("Settings...")
        } preAction: {
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
