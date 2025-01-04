//
//  PermissionsView.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import SwiftUI

struct PermissionsView: View {
    var body: some View {
        VStack {
            Text("Authorize Click")
                .font(.title.bold())
            Text("Click needs you permission to work properly. Follow these steps to authorize it:")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding()

            HStack {
                Text("1.")
                    .foregroundStyle(.secondary)
                Text("Open System Preferences")
                    .bold()
            }
            .padding(1)
            HStack {
                Text("2.")
                    .foregroundStyle(.secondary)
                Text("Privacy & Security")
                    .bold()
            }
            .padding(1)
            HStack {
                Text("3.")
                    .foregroundStyle(.secondary)
                Text("Accessibility")
                    .bold()
            }
            .padding(1)
            HStack {
                Text("4.")
                    .foregroundStyle(.secondary)
                Text("Enable Click")
                    .bold()
            }
            .padding(1)
        }
        .padding()
        .frame(width: 330, height: 300)
    }
}

#Preview {
    PermissionsView()
}
