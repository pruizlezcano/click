//
//  ContentView.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            Text("Click")
                .font(.title.bold())
                .padding()
            if appState.permissionsGranted {
                Text("Permissions granted")
            } else {
                Text("Permissions not granted")
            }
        }
        .padding()
        .frame(width: 330)
    }
}

#Preview {
    ContentView()
}
