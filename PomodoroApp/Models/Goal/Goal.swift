//
//  Goal.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 17.05.2025.
//

import Foundation

struct Goal: Identifiable {
    var id: String
    var title: String
    var dailyMinutes: Int
    var totalSessions: Int
    var tips: [String]
    var colorHex: String
    var createdAt: Date
    var completedSessions: Int
}

