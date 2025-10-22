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
    @Default(.showNotifications) var showNotifications

    private var cornerRadius: CGFloat {
        if #available(macOS 26, *) {
            10
        } else {
            5
        }
    }

    var body: some View {
        TabView {
            generalSettings()
            soundSettings()
            shorcutsSettings()
        }
        .scenePadding()
        .frame(maxWidth: 400)
    }

    private func generalSettings() -> some View {
        VStack {
            VStack(spacing: 0) {
                SettingsToggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        appState.toggleLaunchAtLogin(newValue)
                    }
                Divider()
                    .padding(.horizontal, 8)
                SettingsToggle("Start Minimized", isOn: $startMinimized)
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }

            VStack(spacing: 0) {
                SettingsToggle("Notifications", isOn: $showNotifications)
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
        }
        .toggleStyle(.switch)
        .tabItem {
            Label("General", systemImage: "gear")
        }
    }

    private func soundSettings() -> some View {
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
                Divider()
                    .padding(.horizontal, 8)
                HStack {
                    HStack(spacing: 0) {
                        Text("Output device")
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Picker("", selection: $appState.outputDevice) {
                        ForEach(OutputDevice.allCases, id: \.self) { device in
                            HStack {
                                Image(systemName: device.icon)
                                Text(device.rawValue.capitalized)
                            }
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .padding(.horizontal, 8)
                .frame(minHeight: 34)
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
        }
        .toggleStyle(.switch)
        .tabItem {
            Label("Sound", systemImage: "speaker.wave.2")
        }
    }

    private func shorcutsSettings() -> some View {
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
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
        }
        .tabItem {
            Label("Shortcuts", systemImage: "command")
        }
    }
}

#Preview {
    SettingsView()
}
