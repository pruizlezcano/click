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
                Text("Open System Preferences")
                    .bold()
            }
            HStack {
                Text("Privacy & Security")
                    .bold()
            }
            HStack {
                Text("Accessibility")
                    .bold()
            }
            HStack {
                Text("Enable Click.app")
                    .bold()
            }
        }
        .padding()
        .frame(width: 330, height: 300)
    }
}

#Preview {
    PermissionsView()
}
