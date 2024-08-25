//
//  ContentView.swift
//  click
//
//  Created by Pablo Ruiz on 21/8/24.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var permissionsGranted = PermissionsManager.getStatus()
    @Published var accessibilityChecker: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var accessibilityChecks: Int = 0

    func beginAccessibilityAccessRequest() {
        accessibilityChecker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        accessibilityChecks = 0
        PermissionsManager.showWindow()
    }

    func refreshPermissions() {
        accessibilityChecks += 1
        let isGranted = PermissionsManager.getStatus()
        if isGranted != permissionsGranted {
            PermissionsManager.closeWindow()
            AppState.shared.permissionsGranted = isGranted
            withAnimation {
                permissionsGranted = isGranted
            }
            if isGranted {
                AppState.shared.startApp?()
            }
            if !isGranted {
                beginAccessibilityAccessRequest()
                EventManager.removeEventMonitors()
            }
        }
        if isGranted || accessibilityChecks > 60 {
            accessibilityChecker.upstream.connect().cancel()
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var model = ViewModel()

    var body: some View {
        VStack {
            Text("Click")
                .font(.title.bold())
                .padding()

            if model.permissionsGranted {
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
                    model.beginAccessibilityAccessRequest()
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
                        SoundManager.loadSoundPack(soundpack)
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
        .onReceive(model.accessibilityChecker) { _ in
            model.refreshPermissions()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.shared)
}
