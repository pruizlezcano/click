//
//  PermissionsManager.swift
//  click
//
//  Created by Pablo Ruiz on 24/8/24.
//

import Foundation
import SwiftUI

class PermissionsManager {
    static var permissionsWindow: NSPanel?

    static func getStatus() -> Bool {
        AXIsProcessTrusted()
    }

    static func showWindow() {
        let permissionsView = PermissionsView()
        let hostingController = NSHostingController(rootView: permissionsView)

        // Create a visual effect view
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow

        // Set the contentView of the visual effect view to the SwiftUI view
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // Create a window
        permissionsWindow = NSPanel()
        permissionsWindow?.contentView = visualEffect
        permissionsWindow?.titlebarAppearsTransparent = true
        permissionsWindow?.styleMask.insert(.closable)
        permissionsWindow?.styleMask.insert(.fullSizeContentView)
        permissionsWindow?.styleMask.insert(.borderless)
        permissionsWindow?.isOpaque = false
        permissionsWindow?.backgroundColor = .clear
        permissionsWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        permissionsWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        permissionsWindow?.center()
        permissionsWindow?.makeKeyAndOrderFront(nil)

        // Add constraints to make sure the SwiftUI view takes up the entire visual effect view
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor)
        ])
    }

    static func closeWindow() {
        permissionsWindow?.close()
        permissionsWindow = nil
    }
}
