//
//  NotificationHelper.swift
//  Mingming
//
//  Created by Jerico Villaraza on 3/9/25.
//

import SwiftUI

enum NotificationHelper {
    static func addNotification(id: String, title: String, body: String, date: Date, repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                debugPrint("Error scheduling notifications: \(error)")
            } else {
                debugPrint("Successfully scheduled notifciations")
                debugPrintPendingNotifications()
            }
        }
    }
    
    static func deleteNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        debugPrintPendingNotifications()
    }
    
    private static func debugPrintPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            debugPrint("Pending Notifications")
            for request in requests {
                debugPrint("===================================")
                debugPrint("ID: \(request.identifier)")
                debugPrint("Title: \(request.content.title)")
            }
        }
    }
}
