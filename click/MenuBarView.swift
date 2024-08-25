//
//  MenuBarView.swift
//  click
//
//  Created by Pablo Ruiz on 25/8/24.
//

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

        Menu {
            ForEach(Soundpack.allCases, id: \.self) { soundpack in
                Button {
                    SoundManager.loadSoundPack(soundpack)
                } label: {
                    if soundpack == appState.soundpack {
                        Image(systemName: "checkmark")
                    }
                    Text(soundpack.soundpack?.name ?? soundpack.rawValue)
                }
            }
        } label: {
            Image(systemName: "speaker.wave.2")
            Text("Soundpack")
        }

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
