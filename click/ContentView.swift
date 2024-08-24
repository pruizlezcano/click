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
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Permissions granted")
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 9).stroke(Color.secondary, lineWidth: 0.5)
                    .fill(.secondary.opacity(0.1))
                )
            } else {
                Button(action: {
                    appState.appDelegate?.showPermissionsWindow()
                }, label: {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("Permissions not granted")
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 9).stroke(Color.secondary, lineWidth: 0.5)
                        .fill(.secondary.opacity(0.1))
                    )
                })
                .buttonStyle(.plain)
            }

            Text("Choose your switch set")
                .foregroundStyle(.secondary)
                .padding(.top)

            VStack {
                ForEach(Soundpack.allCases, id: \.self) { soundpack in
                    Button(action: {
                        appState.loadSound(soundPack: soundpack)
                    }, label: {
                        HStack {
                            Spacer()
                            Text(soundpack.soundpack?.name ?? soundpack.rawValue)
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(appState.soundpack == soundpack ? Color.secondary : .clear, lineWidth: 4)
                                .stroke(Color.secondary, lineWidth: 1)
                                .fill(.bar)
                        )
                    })
                    .buttonStyle(.plain)
                }
                .animation(.default, value: appState.soundpack)
            }
            .padding()
        }
        .padding()
        .frame(width: 330)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.shared)
}
