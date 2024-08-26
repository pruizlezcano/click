//
//  SettingsView.swift
//  click
//
//  Created by Pablo Ruiz on 25/8/24.
//

import Defaults
import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}

struct SettingsView: View {
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.startMinimized) var startMinimized

    var body: some View {
        TabView {
            VStack {
                VStack(spacing: 0) {
                    ToggleView("Launch at Login", isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            AppState.shared.toggleLaunchAtLogin(newValue)
                        }
                    Divider()
                        .padding(.horizontal, 8)
                    ToggleView("Start Minimized", isOn: $startMinimized)
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
        }
        .scenePadding()
        .frame(maxWidth: 400)
    }
}

#Preview {
    SettingsView()
}
