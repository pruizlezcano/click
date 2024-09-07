//
//  SettingsView.swift
//  click
//
//  Created by Pablo Ruiz on 25/8/24.
//

import Defaults
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.startMinimized) var startMinimized
    @Default(.overrideVolume) var overrideVolume
    @Default(.customVolume) var customVolume

    var body: some View {
        TabView {
            VStack {
                VStack(spacing: 0) {
                    SettingsToggle("Launch at Login", isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            appState.toggleLaunchAtLogin(newValue)
                        }
                    Divider()
                        .padding(.horizontal, 8)
                    SettingsToggle("Start Minimized", isOn: $startMinimized)
                    Divider()
                        .padding(.horizontal, 8)
                }
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
            }
            .toggleStyle(.switch)
            .tabItem {
                Label("General", systemImage: "gear")
            }

            VStack {
                VStack(spacing: 0) {
                    SettingsToggle("Override volume presets", isOn: $appState.overrideVolume)
                        .onChange(of: appState.overrideVolume) { _, newValue in
                            overrideVolume = newValue
                        }
                    Divider()
                        .padding(.horizontal, 8)
                    SettingsSlider(
                        "Custom volume",
                        value: $appState.customVolume,
                        disabled: !appState.overrideVolume,
                        in: 0.5 ... 10,
                        step: 1,
                        leftIcon: "speaker.fill",
                        rightIcon: "speaker.wave.3.fill"
                    )
                    .onChange(of: appState.customVolume) { _, newValue in
                        customVolume = newValue
                    }
                }
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
            }
            .toggleStyle(.switch)
            .tabItem {
                Label("Sound", systemImage: "speaker.wave.2")
            }

            VStack {
                VStack(spacing: 0) {
                    SettingsShortcutRecorder("Toggle Click", name: .toggle)
                    Divider()
                        .padding(.horizontal, 8)
                }
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
            }
            .tabItem {
                Label("Shortcuts", systemImage: "command")
            }
        }
        .scenePadding()
        .frame(maxWidth: 400)
    }
}

#Preview {
    SettingsView()
}
