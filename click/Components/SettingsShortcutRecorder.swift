//
//  SettingsShortcutRecorder.swift
//  click
//
//  Created by Pablo Ruiz on 7/9/24.
//

import KeyboardShortcuts
import SwiftUI

struct SettingsShortcutRecorder: View {
    let elementMinHeight: CGFloat = 34
    let horizontalPadding: CGFloat = 8

    let title: LocalizedStringKey
    let name: KeyboardShortcuts.Name

    init(
        _ title: LocalizedStringKey,
        name: KeyboardShortcuts.Name
    ) {
        self.title = title
        self.name = name
    }

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(title)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()
            KeyboardShortcuts.Recorder("", name: name)
        }
        .padding(.horizontal, horizontalPadding)
        .frame(minHeight: elementMinHeight)
    }
}

#Preview {
    SettingsShortcutRecorder("Toggle", name: .toggle)
}
