//
//  PermissionsManager.swift
//  click
//
//  Created by Pablo Ruiz on 24/8/24.
//

import Foundation
import SwiftUI

class PermissionsManager {
    static func getStatus() -> Bool {
        AXIsProcessTrusted()
    }
}
