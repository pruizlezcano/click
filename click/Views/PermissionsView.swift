//
//  PermissionsView.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import SwiftUI

struct PermissionsView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Authorize Click")
                    .font(.title.bold())
                Text("Click needs you permission to work properly. Follow these steps to authorize it:")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .frame(minWidth: 225)
            .padding()

            Rectangle()
                .frame(width: 1, height: 300)
                .foregroundColor(.secondary.opacity(0.2))

            VStack(alignment: .leading) {
                HStack {
                    Text("1.")
                        .foregroundStyle(.secondary)
                    Text("Open System Preferences")
                        .font(.title3.bold())
                }
                .padding(1)
                HStack {
                    Text("2.")
                        .foregroundStyle(.secondary)
                    Text("Privacy & Security")
                        .font(.title3.bold())
                }
                .padding(1)
                HStack {
                    Text("3.")
                        .foregroundStyle(.secondary)
                    Text("Accessibility")
                        .font(.title3.bold())
                }
                .padding(1)
                HStack {
                    Text("4.")
                        .foregroundStyle(.secondary)
                    Text("Enable Click")
                        .font(.title3.bold())
                }
                .padding(1)
            }
            .padding()

            Spacer()
        }
    }
}

#Preview {
    PermissionsView()
}
