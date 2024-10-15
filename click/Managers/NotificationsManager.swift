//
//  NotificationsManager.swift
//  click
//
//  Created by Pablo Ruiz on 14/9/24.
//

import Defaults
import Foundation
import UserNotifications

class NotificationsManager {
    static func requestPermission() {
        guard Defaults[.showNotifications] else { return }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }

    static func stateNotification(state: Bool) {
        guard Defaults[.showNotifications] else { return }
        let notification = UNMutableNotificationContent()
        notification.title = "Click"
        notification.body = state ? "Click is now active" : "Click is now inactive"
        notification.sound = .default
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "state", content: notification, trigger: nil))
    }
}
