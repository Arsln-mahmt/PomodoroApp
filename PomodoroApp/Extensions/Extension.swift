//
//  Extensions.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 17.05.2025.
//
import Foundation

extension Int {
    var formattedTime: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension Notification.Name {
    static let goalSessionUpdated = Notification.Name("goalSessionUpdated")
}
